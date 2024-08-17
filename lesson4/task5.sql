--5) Реализовать через буфферную таблицу заполнение stg слоя
create table if not exists stg.crpt_product_line
(
    product_line_id   UInt8 comment 'Идентификатор товарной группы',
    product_line_name String comment 'Наименоваание товарной группы',
    product_line_desc String comment 'Описание товарной группы',
    dt                DateTime64 default now() comment 'Дата вставки в таблицу',
    is_deleted        UInt8      default 0 comment 'Признак удаления'
) engine =ReplacingMergeTree order by product_line_id comment 'ТГ ЦРПТ';

create table if not exists buffer.crpt_product_line_buf
(
    product_line_id   UInt8 comment 'Идентификатор товарной группы',
    product_line_name String comment 'Наименоваание товарной группы',
    product_line_desc String comment 'Описание товарной группы'
) engine = Buffer(stg, crpt_product_line, 16, 10, 100, 1000, 10000, 10000000, 100000000);

insert into buffer.crpt_product_line_buf ( product_line_id, product_line_name, product_line_desc )
values ( 1, 'lp', 'Предметы одежды, бельё постельное, столовое, туалетное и кухонное' )
     , ( 2, 'shoes', 'Обувные товары' )
     , ( 3, 'tobacco', 'Табачная продукция' )
     , ( 4, 'perfumery', 'Духи и туалетная вода' )
     , ( 5, 'tires', 'Шины и покрышки пневматические резиновые новые' )
     , ( 6, 'electronics', 'Фотокамеры (кроме кинокамер), фотовспышки и лампы-вспышки)' )
     , ( 7, 'pharma', 'Лекарственные препараты для медицинского применения' )
     , ( 8, 'milk', 'Молочная продукция' )
     , ( 9, 'bicycle', 'Велосипеды и велосипедные рамы' )
     , ( 10, 'wheelchairs', 'Медицинские изделия' )
     , ( 12, 'otp', 'Альтернативная табачная продукция' )
     , ( 13, 'water', 'Упакованная вода' )
     , ( 14, 'furs', 'Товары из натурального меха' )
     , ( 15, 'beer', 'Пиво, напитки, изготавливаемые на основе пива, слабоалкогольные напитки' )
     , ( 16, 'ncp', 'Никотиносодержащая продукция' )
     , ( 17, 'bio', 'Биологически активные добавки к пище' )
     , ( 19, 'antiseptic', 'Антисептики и дезинфицирующие средства' )
     , ( 22, 'nabeer', 'Безалкогольное пиво' )
     , ( 23, 'softdrinks', 'Соковая продукция и безалкогольные напитки' );