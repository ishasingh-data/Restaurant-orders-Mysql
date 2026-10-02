-- 1 objective
use restaurant_db;

-- 1. view the menu_items table.
select * from menu_items;

-- 2. Find the number of items on the menu.
select count(*) from menu_items;

-- 3. what are the least and most expensive items on the menu?
select min(price) as least_expensive, max(price) as most_expensive from menu_items;

-- 4. how many Italian dishes are on te menu?
select count(*) from menu_items 
where category = 'Italian';

-- 5. What are the least and most expensive Italian dishes on the menu?
select * 
from menu_items 
where Price = (select min(price) from menu_items WHERE category = 'Italian')
 and category = 'Italian'
UNION ALL
select * 
from menu_items 
where Price = (select max(price) from menu_items WHERE category = 'Italian')
 and category = 'Italian';
 
-- 6. How many dishes are in each category?
select count(*), category as num_dishes
from menu_items
group by category
order by num_dishes;

-- 7. What is the average dish price within each category?
select category, avg(price) as avg_price_dishes
from menu_items
group by  category;

-- 2 objective
use restaurant_db;

-- 1. View the order_details table.
select *
from order_details; 

-- 2. What is the data range of the table ?
select min(order_date) as starting_date
, max(order_date) as ending_date 
from order_details;

-- 3. How many order were made within this date range?
select  count(distinct order_id) ,min(order_date) as starting_date
, max(order_date) as ending_date 
from order_details;
-- 4. How many items were ordered within this date range?
select  count(*)  
from order_details
where order_date between 
	(select min(order_date) from order_details)
    and 
    (select max(order_date) from order_details);
    
-- 5. Which order had the most number of items ?
select order_id , count(item_id) as num_items 
from order_details
group by order_id
order by num_items desc;
-- 6. How many orders had more than 12 items?
select count(*)
from 
(select order_id , count(item_id) as num_items
from order_details
group by order_id 
having num_items > 12
order by num_items ) as num_orders;

-- 3 objective
-- 1. Combine the menu_items and order_details table into a single table.
select * from menu_items
join order_details
on menu_items.menu_item_id= order_details.item_id;
 
 select *
 from order_details od left join menu_items mi
	on od.item_id = mi.menu_item_id;
-- 2. what were the least and most  ordered items? What categories were they in ?
(select item_name, count(order_details_id) as num_purchase, category
from order_details od left join menu_items mi
on od.item_id = mi.menu_item_id
group by item_name, category
order by num_purchase desc
limit 1)
union all
(select item_name , count(order_details_id) as num_purchase , category
from order_details od left join menu_items mi
on od.item_id = menu_item_id
group by item_name , category
order by num_purchase asc
limit 1);

-- 3. What were the top 5 orders that spent the most money?
select order_id , sum(price) as total_spend
from order_details od 
left join menu_items mi on od.item_id = mi.menu_item_id
group by order_id 
order by total_spend desc
limit 5;
-- 4. View the details of the highest spend order. What insights can you agther from the result?
select category, count(item_id) as num_items
from order_details od 
left join menu_items mi on od.item_id = mi.menu_item_id
where order_id = 440
group by category;
-- 5. Veiw the details of the top 5 hightest spend orders. What insights can gather from the results?
select order_id, category, count(item_id) as num_items
from order_details od 
left join menu_items mi on od.item_id = mi.menu_item_id
where order_id in ( 440, 2075, 1957, 330, 2675)
group by category, order_id;
