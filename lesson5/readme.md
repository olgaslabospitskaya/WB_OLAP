структура бд + таблица
![image](https://github.com/user-attachments/assets/e1b40a45-7c52-45cd-998f-dc61114eb011)

```
create table default.shk_excise_crpt_log
(
    shk_id            UInt64,
    ext_id            String,
    group_id          UInt8,
    product_line_name String,
    entry             LowCardinality(String)
)
    engine = MergeTree order by shk_id;

```

топик кафки
![image](https://github.com/user-attachments/assets/d3b13660-6504-44b1-b832-e1117161b799)

консоль
![image](https://github.com/user-attachments/assets/3ad176b1-20e8-4078-a931-4783bfb7c4e0)

мастер
![image](https://github.com/user-attachments/assets/d0094ff2-b47a-4ff1-a61f-86a1832292f5)

воркер
![image](https://github.com/user-attachments/assets/aabedef0-3b87-4240-8432-b4317279ad7b)
лог воркера
![image](https://github.com/user-attachments/assets/2be93f15-2d18-4b46-93f1-a5aaac84093f)





