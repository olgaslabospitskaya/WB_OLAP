--6) Создать матереализованное представление для перемещения данных из stg слоя в слой текущих данных
create table if not exists current.crpt_product_line
(
    product_line_id   UInt8 comment 'Идентификатор товарной группы',
    product_line_name String comment 'Наименоваание товарной группы',
    product_line_desc String comment 'Описание товарной группы',
    dt                DateTime64 default now() comment 'Дата вставки в таблицу',
    is_deleted        UInt8      default 0 comment 'Признак удаления'
) engine = ReplacingMergeTree order by product_line_id comment 'ТГ ЦРПТ';

create materialized view if not exists stg.crpt_product_line_mv to current.crpt_product_line as
select *
from stg.crpt_product_line;

