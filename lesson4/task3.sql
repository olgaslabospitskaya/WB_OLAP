--3) Создать базы для стейджинга, исторических данных, текущих данных и буферных таблиц
create database if not exists stg comment 'стейджинг';
create database if not exists current comment 'текущие данные';
create database if not exists history comment 'исторические данные';
create database if not exists buffer comment 'буферные таблицы';
