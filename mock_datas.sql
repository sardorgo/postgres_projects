---Mock data for components

insert into components(name) values ('Sabzi'),('Piyoz'),('Kartoshka'),('Go''sht'),('Ziravorlar'),('Pamidor'),('Bodiring');

---Mock datas for categories

insert into categories(name) values ('Milliy Taomlar'),('Evropa Taomlar'),('Turk Taomlar'),('Qo''shimchalar');	
insert into categories(name) values ('Ichimliklar');

---Mock datas for types

insert into types(name) values ('Quyuq Ovqatlar'),('Suyuq ovqatlar'),('Salatlar'),('Shirinliklar'), ('Salqin Ichimliklar'),('Issiq ichimliklar');
insert into types(name) values ('Non mahsulotlari');
---Mock datas for type_register

insert into type_register (category_id, type_id) values (1,1), (1, 2),(1, 6);
insert into type_register (category_id, type_id) values (2,1), (2, 2), (2, 4), (3, 5);
insert into type_register (category_id, type_id) values (5, 5), (5, 6);

insert into type_register (category_id, type_id) values (4, 7);
insert into type_register (category_id, type_id) values (2, 3);

---Mock datas for tables

insert into tables (number) values (1), (2), (3), (4), (5);

---Mock datas for products;

insert into products (name, price, type_register_id) values ('Osh', 25000, 1);
insert into products (name, price, type_register_id) values ('Qozon Kabob', 40000, 1);
insert into products (name, price, type_register_id) values ('Mastava', 15000, 2);
insert into products (name, price, type_register_id) values ('Sho''rva', 20000, 2);
insert into products (name, price, type_register_id) values ('Qora Choy', 5000, 9);
insert into products (name, price, type_register_id) values ('Ko''k Choy', 5000, 9);
insert into products (name, price, type_register_id) values ('Pepsi', 10000, 8);
insert into products (name, price, type_register_id) values ('Cola', 10000, 8);

insert into products (name, price, type_register_id) values ('Non', 5000,10);
insert into products (name, price, type_register_id) values ('Go''shtli Non', 10000,10);
insert into products (name, price, type_register_id) values ('Olive', 15000,11);


---Mock data for orders and order_details


insert into orders(table_id) values (1);

insert into order_details(quantity, order_id, product_id) values (2, 1, 1);
insert into order_details(quantity, order_id, product_id) values (1, 1, 5);

insert into orders (table_id) values (2);

insert into order_details(quantity, order_id, product_id) values (2, 2, 1);
insert into order_details(quantity, order_id, product_id) values (1, 2, 7);
insert into order_details(quantity, order_id, product_id) values (1, 2, 8);

insert into orders (table_id) values (3);

insert into order_details(quantity, order_id, product_id) values (1, 3, 2);
insert into order_details(quantity, order_id, product_id) values (1, 3, 5);

insert into orders (table_id) values (4);

insert into order_details(quantity, order_id, product_id) values (2, 4, 3);
insert into order_details(quantity, order_id, product_id) values (2, 4, 8);


--------------------------------------------------------------

update orders set closed_at = current_timestamp where order_id = 1;
update orders set closed_at = current_timestamp where order_id = 2;
update orders set closed_at = current_timestamp where order_id = 3;
update orders set closed_at = current_timestamp where order_id = 4;
