--4)Создать роль только для чтения и роль с возможность создавать и заполнять данные в БД стейджинга(stg).
-- Создать двух пользователей с такими правами по умолчанию.
create role if not exists read_all;
grant select on *.* to read_all;
create user if not exists reader identified with sha256_password by 'reader' default role read_all;

create role if not exists stg_creator;
grant create table, select, insert on stg.* to stg_creator with grant option;
create user if not exists stg_user identified with sha256_password by 'stg_user' default role stg_creator;

