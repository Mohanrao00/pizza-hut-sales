create database Pizza_Hut_Project;

select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;


create table orders(order_id int not null,
order_date date not null,
order_time time,
primary key (order_id));



create table order_details(order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key(order_details_id));












-- BASIC PROBLEMS

-- Retrieve the total number of orders placed.     1



SELECT 
    COUNT(order_id) as total_orders
FROM
    orders;



-- Calculate the total revenue generated from pizza sales.         2

SELECT 
    ROUND(SUM(p.price * od.quantity), 2) AS Total_Revenue
FROM
    pizzas AS p
        JOIN
    order_details AS od ON p.pizza_id = od.pizza_id;





-- Identify the highest-priced pizza  3



SELECT 
    pt.name, p.price 
FROM
    pizza_types as pt 
    join pizzas as p
    on pt.pizza_type_id = p.pizza_type_id
ORDER BY price DESC
LIMIT 1;







-- Identify the most common pizza size ordered      4




SELECT p.size ,count(od.order_details_id) as comon_pizza_ordered
from pizzas as p
join order_details as od
on p.pizza_id = od.pizza_id
group by p.size order by comon_pizza_ordered desc;

 
 
 
-- List the top 5 most ordered pizza types along with their quantities.      5

  select p.pizza_type_id, sum(od.quantity) as most_ordered
  from pizzas as p
  join order_details as od
  on p.pizza_id = od.pizza_id
  group by p.pizza_type_id 
  order by most_ordered desc
  limit 5;













select * from pizzas;
select * from pizza_types;
select * from orders;
select * from order_details;




-- INTERMEDIATE PROBLEMS

-- Join the necessary tables to Find the total quantity of each pizza category ordered.        1


SELECT pt.category , sum(od.quantity) total_quantity
from pizza_types as pt
join pizzas as p
on p.pizza_type_id = pt.pizza_type_id
join order_details as od
on p.pizza_id = od.pizza_id
group by pt.category
order by total_quantity desc;











-- Determine the distribution of orders by hour of the day.  2


SELECT 
    HOUR(order_time), COUNT(order_id) AS orders
FROM
    orders
GROUP BY HOUR(order_time)
ORDER BY orders DESC;






-- Join relevant tables to Find the category-wise distribution of pizzas.     3

SELECT category, COUNT(pizza_type_id)
FROM  pizza_types
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day.    4


select round(avg(quantity),2)  as avg_pizzas_sales from 
( select o.order_date , sum(od.quantity) as quantity from orders as o
 join order_details as od
 on o.order_id = od.order_id 
 group by o.order_date
 ) as order_qty;




-- Determine the top 3 most ordered pizza types based on revenue.           5

select  p.pizza_type_id , sum(p.price* od.quantity) as revenue
from pizzas as p 
join order_details as od
on p.pizza_id = od.pizza_id
group by p.pizza_type_id
order by revenue desc
limit 3;















-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.  


SELECT
    pt.category,
    ROUND (SUM(od.quantity * p.price) /
        (SELECT SUM(od.quantity * p.price)
         FROM order_details od
         JOIN pizzas p
         ON p.pizza_id = od.pizza_id) * 100,
        2
    ) AS revenue
FROM pizza_types pt
JOIN pizzas p
    ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od
    ON od.pizza_id = p.pizza_id
GROUP BY pt.category
ORDER BY revenue ;



-- Analyze the cumulative revenue generated over time.

select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from 
(select o.order_date,
sum(od.quantity * p.price) as revenue
from order_details 
od 
join pizzas as p
on od.pizza_id = p.pizza_id
join orders as o
on o.order_id = od.order_id
group by o.order_date) as sales;






-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.



select name,revenue from
(select category,name, revenue, 
rank() over( partition by category order by revenue desc) as rn 
from 
(select pt.category, pt.name,
sum((od.quantity)* p.price) as revenue
from pizza_types as pt 
join pizzas as p
on pt.pizza_type_id = p.pizza_type_id
join order_details as od
on od.pizza_id = p.pizza_id
group by pt.category, pt.name) as a) as b
where rn <=3;




