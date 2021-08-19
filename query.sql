---Bugungi buyurtmalar
---Eng ko'p buyurtma qilingan mahsulot
---Biror tovar bilang eng ko'p buyurtma qilingan boshqa tovar
---eng faol buyurtmalar kuni
---Karmonga qarab mahsulot tavsiya qilish
---Odatda odamlar qancha vaqt o'tirishdi


------------------------------------------------------------

select 
	o.*
from orders as o
where created_at::date = current_date and o.closed_at is not null
;

------------------------------------------------------------

select
	od.product_id,
	p.name,
	sum(od.quantity) as amount
from 
	order_details as od
join products as p on p.product_id = od.product_id
group by od.product_id, p.name
order by amount desc
limit 1
;

----------------------------------------------------------------
--Praktika

select
	p.name,
	count(ord.product_id) as amount
from
	order_details as ord
join products as p on p.product_id = ord.product_id
group by p.name
order by amount desc limit 1
;

----------------------------------------------------------------


select 
	t.type_id,
	t.name,
	p.name,
	sum(ord.quantity) as quantity,
	ord.product_id
from 
	order_details as ord
join products as p on p.product_id = ord.product_id
join types as t on t.type_id = p.type_id
group by t.name, t.type_id, p.name, ord.product_id
order by quantity desc
;

------------------------------------------

select
	t.name,
	p.name,
	count(ord.product_id)
from types as t
join products as p on p.type_id = t.type_id
join order_details as ord on ord.product_id = p.product_id
group by t.name, p.name
;

-------------------------------------------

--Praktika 2

select
  --o.order_id as orders,
  array_agg(p.name) as name,
  sum(od.quantity) as quantity,
  tr.type_id as type 
from orders as o
join order_details as od on od.order_id = o.order_id
join products as p on od.product_id = p.product_id
join type_register as tr on tr.type_register_id = p.type_register_id
group by type
order by quantity desc 
;


------------------------------------------------------------------------

---Uy ishi - 1

select
		sum(extract(minute from o.closed_at - o.created_at)) / count(o.order_id)
from 
	orders as o
;

------------------------------------------------------------------------

---Uy ishi-2

select
	extract(dow from o.created_at) as day, 
	count(extract(dow from o.created_at)) as amount,
	count(o.table_id)

from 
	orders as o
join order_details as ord on ord.order_id = o.order_id
group by day
;

-------------------------------------------------------------------------


---------
-- Praktika
-- day 10
-- month Avgust
-- year 2021


select
	sum(d.quantity),
	p.name,
	p.type_register_id,
	d.product_id
from
	order_details as d
join 
	products as p using(product_id)
group by 
	d.product_id, 
	p.type_register_id, 
	p.name
order by 
	p.type_register_id, 
	sum(d.quantity) desc
;

-------------------------------------------------------------------------

