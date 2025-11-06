
			-- A.SQL QUERIES For KPI
	--Sum of sales of all the pizza orders?
select SUM(total_price) as Total_Revenue from pizza_sales

	--The average amount spent per order?
select SUM(total_price) / COUNT(distinct(order_id)) as Avg_Order_Value from pizza_sales

	--The sum of quantities of all pizzas sold?
select SUM(quantity) as Total_Pizzas_Sold from pizza_sales

	--The total number of orders placed?
select COUNT(distinct order_id) as Total_Orders from pizza_sales

	--The average pizzas per order?
select cast(cast(SUM(quantity) as decimal(10,2)) / cast(COUNT(distinct order_id) as decimal(10,2)) as decimal(10,2)) from pizza_sales

			--B. CHART REQUIREMENTS
	--daily trend for total orders
select DATENAME(DW,order_date) as order_day,COUNT(distinct order_id) order_count from pizza_sales group by DATENAME(DW,order_date)

	--hourly trend for total orders
select concat(DATEPART(HOUR,order_time),':00') as hour_, COUNT(distinct order_id) as order_count from pizza_sales group by DATEPART(HOUR,order_time) order by hour_ asc

	--monthly trend for total sales
select DATENAME(MONTH,order_date) as month_name,cast(sum(total_price)as decimal(10,2)) as total_sales from pizza_sales group by DATENAME(MONTH,order_date) order by total_sales asc

	-- percentage of sales by pizza category
with cts_ as(
select pizza_category,cast(sum(total_price)as decimal(10,2)) as total_sales from pizza_sales group by pizza_category ) 
select pizza_category,total_sales,SUM(total_sales) over() as all_total_sales , concat(cast((total_sales/SUM(total_sales) over() ) * 100 as decimal(10,2)) , '%') as percentage_ from cts_

	-- % of sales by pizza size
	with size_cts as (
select pizza_size,cast(SUM(total_price) as decimal(10,2)) as total_sales from pizza_sales group by pizza_size )
select pizza_size,total_sales,cast(SUM(total_sales)  over() as decimal(10,2)) as all_total_sales, concat(cast((total_sales/cast(SUM(total_sales) over() as decimal(10,2)) * 100 ) as decimal(10,2)) ,'%')from size_cts

	--top 5 sellers by revenue
select top 5 pizza_name,sum(total_price) as total_sales from pizza_sales group by pizza_name order by total_sales desc

	--least 5 selling pizzas 
select top 5 pizza_name,COUNT(distinct order_id) as order_count from pizza_sales group by pizza_name order by order_count asc
select * from pizza_sales

