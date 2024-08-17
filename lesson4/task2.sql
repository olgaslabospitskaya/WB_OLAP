--2) Настроить пользователя администратора
create user admin identified with sha256_password by 'admin';
create role admin_role;
grant current grants on *.* to admin_role with grant option;
grant admin_role to admin;

