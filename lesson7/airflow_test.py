from airflow import DAG
from airflow.operators.python import PythonOperator
from clickhouse_driver import Client
import psycopg2, json
from sqlalchemy import create_engine


dag = DAG(dag_id="report_crpt", tags=["aaaaa"])

def main():  

    with open(r"/opt/airflow/dags/wb_key.json") as json_file:
      сonnect_settings = json.load(json_file)

    client_CH = Client(
      сonnect_settings["ch_local"][0]["host"],
      user=сonnect_settings["ch_local"][0]["user"],
      password=сonnect_settings["ch_local"][0]["password"],
      verify=False,
      database="default",
      settings={"numpy_columns": True, "use_numpy": True},
      compression=False,
    )


    client_PG = psycopg2.connect(
      host=сonnect_settings["pg_local"][0]["host"],
      user=сonnect_settings["pg_local"][0]["user"],
      password=сonnect_settings["pg_local"][0]["password"],
      dbname="postgres", 
    )

    
    # Вставка в схему репортс
    client_CH.execute(f"""
    create table if not exists report.shk_excise_crpt_log
    (
        shk_id          UInt64,
        ext_id          String,
        group_id        UInt64,
        product_line_name String,
        entry LowCardinality(String)
    )
        engine = MergeTree order by shk_id
            """)    
    
    print('create table if not exists report.shk_excise_crpt_log')

    client_CH.execute(f"""
    insert into report.shk_excise_crpt_log
    select shk_id
         , ext_id        
         , group_id  
         , product_line_name 
         , 'crpt'
    from tmp.shk_excise_crpt_log cr
    any left join  current.crpt_product_line pl
    on pl.product_line_id=cr.group_id   
            """)     
    
    print('insert into report.shk_excise_crpt_log')
       
    df = client_CH.query_dataframe(
        f"""
        select distinct shk_id
             , replaceAll(ext_id, '\\'', '\\'\\'') ext_id
             , group_id  
             , product_line_name 
             , entry 
        from report.shk_excise_crpt_log
       """
    )
   
    cursor = client_PG.cursor()
    df = df.to_json(orient="records", date_format="iso")
    cursor.execute(f"""CALL sync.shk_excise_crpt_log_import(_src := '{df}')""")

    client_PG.commit()
    cursor.close()
    client_PG.close()
    print('CALL sync.shk_excise_crpt_log_import')

    
PythonOperator(task_id="dag", python_callable=main, dag=dag)