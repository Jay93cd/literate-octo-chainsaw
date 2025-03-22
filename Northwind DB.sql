select * from products
select * from categories
select * from order_details

----------------------------------------------------------------------------------------
---Product Name and Quantity/Unit
select product_name, quantity_per_unit
from products

----------------------------------------------------------------------------------------
---- Product ID and Name
select product_id, product_name
from products

----------------------------------------------------------------------------------------
---- Products by Category
select p.product_name product, c.category_name category
from products p
join categories c using (category_id)

----------------------------------------------------------------------------------------
---- Discontinued Product List	
select product_id, product_name
from products
where discontinued = 1

----------------------------------------------------------------------------------------
---- Most Expensive and Least Expensive Products
(select product_name,unit_price
from products 
order by unit_price desc
limit 1)
union
(select product_name,unit_price
from products 
order by unit_price
limit 1)

----------------------------------------------------------------------------------------
---Product list where current product cost less than $20
select product_id, product_name, unit_price
from products
where discontinued = 0 and unit_price < 20

----------------------------------------------------------------------------------------
---Cost of Products Between $15 and $25
select product_id, product_name, unit_price
from products
where unit_price between 15 and 25

----------------------------------------------------------------------------------------
---Products Above Average Price
select product_name,unit_price
from products
where unit_price > (select avg(unit_price) from products);

----------------------------------------------------------------------------------------
--- 10 Most Expensive Products
select product_name,unit_price
from products
order by unit_price desc
limit 10

----------------------------------------------------------------------------------------
---- Count of Current and Discontinued Products
select 
	    sum(case when discontinued = 0 then 1 else 0 end) as current_products,
	    sum(case when discontinued = 1 then 1 else 0 end) as discontinued_products
from products

----------------------------------------------------------------------------------------
--- Product List Less Than Quantity on Order
select product_name,units_on_order,units_in_stock
from products
where units_in_stock < units_on_order;

----------------------------------------------------------------------------------------
--- Employee and Sales Amount
select concat(first_name,' ',last_name) full_name, 
	   round(sum(od.quantity*od.unit_price*(1-od.discount))::numeric,2) total_sales
from employees e
join orders o using (employee_id)
join order_details od using (order_id)
group by full_name
order by total_sales desc

----------------------------------------------------------------------------------------
--- Order and Sales Price after Discount
select order_id,unit_price,quantity,(unit_price*quantity) as total_price,
	   (unit_price*quantity)*(1-discount/100) as sales_price
from order_details	 

----------------------------------------------------------------------------------------
--- Category, Products Sold and Total Sales per Products
select p.product_name product, c.category_name category,
	   (od.unit_price*od.quantity)*(1-od.discount/100) as total_sales
from products p
join categories c using (category_id)
join order_details od using (product_id)

----------------------------------------------------------------------------------------
---- Show Sales Data by categories for 1997 alone
select c.category_name, 
	   round(sum(od.quantity*od.unit_price*(1-od.discount))::numeric,2) total_sales
from order_details od
join products p using (product_id)
join categories c using (category_id)
join orders o using (order_id)
where extract(year from o.order_date) = 1997
group by c.category_name


