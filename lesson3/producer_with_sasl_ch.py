import json
from confluent_kafka import Producer
from clickhouse_driver import Client

config = {
    'bootstrap.servers': 'localhost:9093',  # адрес Kafka сервера
    'client.id': 'simple-producer',
    'sasl.mechanism':'PLAIN',
    'security.protocol': 'SASL_PLAINTEXT',
    'sasl.username': 'admin',
    'sasl.password': 'admin-secret'
}

producer = Producer(**config)

def delivery_report(err, msg):
    if err is not None:
        print(f"Message delivery failed: {err}")
    else:
        print(f"Message delivered to {msg.topic()} [{msg.partition()}] at offset {msg.offset()}")

def send_message(data):
    try:
        # Асинхронная отправка сообщения
        producer.produce('table_topic', data.encode('utf-8'), callback=delivery_report)
        producer.poll(0)  # Поллинг для обработки обратных вызовов
    except BufferError:
        print(f"Local producer queue is full ({len(producer)} messages awaiting delivery): try again")



with open(f"/home/olya/Work/WB/Income/IncomeGIT/keys/wb_key_ch.json") as json_file:
    data = json.load(json_file)

client = Client(data['server'][0]['host'],
                user=data['server'][0]['user'],
                password=data['server'][0]['password'],
                verify=False,
                database='default',
                settings={"numpy_columns": True, 'use_numpy': True},
                compression=True) 

res = client.execute(f"""
      select 
      toJSONString(map('product_line_id', toString(product_line_id), 
                        'product_line_desc', product_line_desc))  from dict_CrptProductLine""")

if __name__ == '__main__':
    for row in res:      
       send_message(row.item())
    producer.flush()