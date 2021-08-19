--The name of db is real_app;

create or replace function drink_advisor(prod_id int) returns varchar language plpgsql as 
	$$
		declare 
			j record;
			pr_id int := prod_id;
			counter_tea_black int := 0;
			counter_tea_green int := 0;
			counter_pepsi int := 0;
			counter_cola int := 0;
			result varchar;
			i record;

		begin
			for i in 
				select
					t.table_id as t,
					array_agg(p.name) as name,
					count(p.name) as amount,
					ord.order_id,
					array_agg(ord.product_id) as p_id
				from
					tables as t
				join orders as o on o.table_id = t.table_id
				join order_details as ord on ord.order_id = o.order_id
				join products as p on p.product_id = ord.product_id
				where ord.product_id = pr_id or ord.product_id = 6 or ord.product_id = 5 or ord.product_id = 7
				group by t.table_id, ord.order_id

				loop

				if i.amount != 1 then
					if i.p_id[1] = 5 or i.p_id[2] = 5 then
						counter_tea_black := counter_tea_black + 1;
					
					elsif i.p_id[1] = 6 or i.p_id[2] = 6 then
						counter_tea_green := counter_tea_green + 1;

					elsif i.p_id[1] = 7 or i.p_id[2] = 7 then
						counter_pepsi := counter_pepsi + 1;

					elsif i.p_id[1] = 8 or i.p_id[2] = 8 then
						counter_cola := counter_cola + 1;

					end if;

				end if;

			end loop;

			raise info 'Cola - %', counter_cola;
			raise info 'Peps - %', counter_pepsi;
			raise info 'Qora Choy - %', counter_tea_black;
			raise info 'Ko''k choy - %', counter_tea_green;


			if counter_tea_black >= counter_tea_green and counter_tea_black >= counter_pepsi and counter_tea_black >= counter_cola then
				result := (select name from products where product_id = 5);
				return result || ' tavsiya qilamiz';

			elsif counter_tea_green >= counter_tea_black and counter_tea_green >= counter_pepsi and counter_tea_green >= counter_cola then
				result := (select name from products where product_id = 6);
				return result || ' tavsiya qilamiz';

			elsif counter_pepsi >= counter_tea_black and counter_pepsi >= counter_tea_green and counter_pepsi >= counter_cola then
				result := (select name from products where product_id = 7);
				return result || ' tavsiya qilamiz';

			elsif counter_cola >= counter_pepsi and counter_cola >= counter_tea_green and counter_cola >= counter_tea_black then
				result := (select name from products where product_id = 8);
				return result || ' tavsiya qilamiz';

			elsif counter_pepsi = counter_tea_green and counter_tea_green = counter_tea_black and counter_tea_black = counter_cola then
				result := 'Ichimliklar orasidagi farq ozaro teng ekan';
				return result;

			end if;

		end;
	$$
;

--------------------------------------------------------------

select
	t.table_id as t,
	array_agg(p.name),
	count(p.name) as amount,
	ord.order_id,
	array_agg(ord.product_id) as p_id
from
	tables as t
join orders as o on o.table_id = t.table_id
join order_details as ord on ord.order_id = o.order_id
join products as p on p.product_id = ord.product_id
where ord.product_id = 1 or ord.product_id = 5 or ord.product_id = 6 or ord.product_id = 7 or ord.product_id = 8
group by t.table_id, ord.order_id
;


---------------------------------------------------------------

--- Stack function

--- Reja ---
-- 1 - Pulni productlar ichidagi minimal qiymatdagi narx bilan solishtirish
-- 2 - Pulni maksimal qiymatdan kamida 1.5 yoki 2 (va unda yuqori) 
-- 	   barobar ko'pligini tekshirish

-- 3 - Pulni qisimlarga bo'lib olish
-----------------------------------------------------------------



create or replace function stack(amount int) returns varchar language plpgsql as
	
	$$
		declare
			cash int := amount;
			temp_cash int := cash;
			cash_for_meal int := (amount/100) * 60;
			cash_for_drinkings int := (amount/100) * 10;
			cash_for_breads int := (amount/100) * 10;
			cash_for_salads int := (amount/100) * 20;

			max_amount int := (select max(price) from products);

			result_for_meal varchar;
			result_for_drinkings varchar;
			result_for_breads varchar;
			result_for_salads varchar;

			outcome int;

		begin
			if cash >= max_amount * 2 then

				result_for_meal := 
				(
					select name from products
					where price between (select min(price) from products where type_register_id in (1, 2)) and cash_for_meal and
					type_register_id in(1, 2)
					order by price desc
					limit 1
				);

				outcome := (select price from products where name = result_for_meal);
				cash := cash - outcome;

				result_for_drinkings := 
				(
					select name from products
					where price between (select min(price) from products where type_register_id in (8, 9)) and cash_for_drinkings and
					type_register_id in(8, 9)
					order by price desc
					limit 1
				);

				outcome := (select price from products where name = result_for_drinkings);
				cash := cash - outcome;

				result_for_breads := 
				(
					select name from products
					where price between (select min(price) from products where type_register_id in (10)) and cash_for_breads and
					type_register_id in(10)
					order by price desc
					limit 1
				);

				outcome := (select price from products where name = result_for_breads);
				cash := cash - outcome;

				result_for_salads := 
				(
					select name from products
					where price between (select min(price) from products where type_register_id in (11)) and cash_for_salads and
					type_register_id in(11)
					order by price desc
					limit 1
				);

				outcome := (select price from products where name = result_for_salads);
				cash := cash - outcome;
	
				raise info 'O''zingiz bilan qoladigan mablag'' >>> %', cash;
				return result_for_meal || ' -- ' || result_for_drinkings || ' -- ' || result_for_breads || ' -- ' || result_for_salads;

            elsif cash < max_amount * 2 and cash >= 0 and cash > (select min(price) from products where type_register_id in(1, 2) limit 1) then
                result_for_meal := (
                    select name from products
                    where type_register_id in (1, 2) and price between (select min(price) from products where type_register_id in (1, 2) limit 1) and
                    (select min(price) from products where type_register_id in (1, 2) limit 1) + 5000
                    order by price asc
                    limit 1
                );

                outcome := (select price from products where name = result_for_meal);
                cash := cash - outcome;

                if cash >= (select min(price) from products where type_register_id in (8,9) limit 1) then
                	result_for_drinkings := (
                		select name from products where price = (select min(price) from products where type_register_id in (8, 9)) 
                		order by price desc
                		limit 1
                	);

                	outcome := (select price from products where name = result_for_drinkings);
                	cash := cash - outcome;
                end if;

                if cash >= (select min(price) from products where type_register_id in (10) limit 1) then 
                	result_for_breads := (
                		select name from products where price = (select min(price) from products where type_register_id in (10)) and
                		type_register_id in (10)
                		order by price desc
                		limit 1
                	);

                	outcome := (select price from products where name = result_for_breads);
                	cash := cash - outcome;

                end if;

                if cash >= (select min(price) from products where type_register_id in (11) limit 1) then
                	result_for_salads := (
                		select name from products where price = (select min(price) from products where type_register_id in (11)) and
                		type_register_id in (11)
                		order by price desc
                		limit 1
                	);

                	outcome := (select price from products where name = result_for_salads);
                	cash := cash - outcome;

                end if;

                raise info 'O''zingiz bilan qoladigan mablag'' >>> %', cash;

                -- return result_for_meal || ' -- ' || result_for_drinkings || ' -- ' || result_for_breads || ' -- ' || result_for_salads;

                raise info '% -- % -- % -- %', result_for_meal, result_for_drinkings, result_for_breads, result_for_salads;
                
                return 'Xaridingiz uchun rahmat';
			
			end if;
		end;
	$$
;



--------------------------------------------------------------------------------------------------

select min(price) from products
where type_register_id in(1, 2);

select name from products
where price between (select min(price) from products where type_register_id in (10)) and 7000 and
type_register_id in(10)
order by price desc
limit 1
;