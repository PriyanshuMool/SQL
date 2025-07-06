-- table information
desc clean_data
;

-- first 5 records
select *
from clean_data
limit 5
;

-- show the datatypes of each column
show columns from clean_data from dqlab_store_sales
;

-- the order_date column is of 'text' type, we need to change it to 'date' type
-- step 1: add a new column
ALTER TABLE clean_data ADD COLUMN date_temp DATE;
-- step 2: set safe mode to off and Copy and convert the text data into the new column
set sql_safe_updates = 0;

UPDATE clean_data
SET date_temp = STR_TO_DATE(order_date, '%Y-%m-%d');

-- step 3: Check for any rows that failed to convert
SELECT order_date
FROM clean_data
WHERE date_temp IS NULL AND order_date IS NOT NULL;

-- step 4: Drop the old column
ALTER TABLE clean_data DROP COLUMN order_date;

-- step 5: Rename the new column to the original name
ALTER TABLE clean_data CHANGE COLUMN date_temp order_date DATE;

-- first 5 records
select *
from clean_data
limit 5
;

-- show the datatypes of each column
show columns from clean_data from dqlab_store_sales
;

-- TASK 01: Order numbers and total sales from 2009 until 2012 which order status is finished
-- TASK 02: Total sales for each sub-category of product on 2011 and 2012
-- TASK 03: The effectiveness and efficiency of promotions carried out so far, by calculating the burn rate of the overall promotions by year
-- TAKS 04: The effectiveness and efficiency of promotions carried out so far, by calculating the burn rate of the overall promotions by sub-category of product on 2012
-- TASK 05: The number of customers transactions for each year
-- TASK 06:The number of new customers for each year


-- TASK 01: Order numbers and total sales from 2009 until 2012 which order status is finished

SELECT YEAR(order_date) as years, SUM(sales) as sales, COUNT(order_status) as 'number of order'
from clean_data
where order_status = 'Order Finished'
group by 1 # to get the value by years, we should put GROUP BY 1 on the query since year field is located in the first column.
;

-- TASK 02: Total sales for each sub-category of product on 2011 and 2012
select *
from clean_data
limit 5
;

select *, round((sales2012 - sales2011) * 100 / sales2012, 1) as 'growth sales(%)'
from (
	select product_sub_category, sum(if(year(order_date) = 2011, sales, 0)) sales2011,
			sum(if(year(order_date) = 2012, sales, 0)) sales2012
    from clean_data
    where order_status = 'Order Finished'
    group by product_sub_category
) sub_category
order by 4 desc
;

-- Here the pivot table was used to compare the total sales in 2011 with 2012. We can
-- use SUM() function followed by IF() function to do it. SUM() is used to get the total
-- sales and IF() used to filter by year that we want to specify.


-- Most the growth sales are lead the increases, shown by a positive value. But there
-- are some sub-category products that got a decline in sales from 2011 to 2012 which
-- shown by a negative value. Labels, Copiers & Fax and tables are the categories that got
-- a decline in sales the most.

-- TASK 03: The effectiveness and efficiency of promotions carried out so far, by calculating the burn rate of the overall promotions by year
select *
from clean_data
limit 5
;

-- burn rate(%) = (total discount / total sales) * 100

select year(order_date) as years, sum(sales) as sales, sum(discount_value) as 'promotional value', round(sum(discount_value) * 100 / sum(sales), 2) as 'burn rate (%)'
from clean_data
where order_status = 'Order Finished'
group by 1
;

-- The results inform us that burn rates are above 4.5% for each year as overall. This
-- indicates that the promotions have been carried out haven’t been able to reduce the
-- burn rate to a maximum of 4.5%. We can figure out what is the product which made
-- a significant contribution causing the burn rate to be higher than expected by
-- grouping the query by each product.

-- TAKS 04: The effectiveness and efficiency of promotions carried out so far, by calculating the burn rate of the overall promotions by sub-category of product on 2012
select product_sub_category, product_category, sum(sales) as sales, sum(discount_value) as promotional_value, round(sum(discount_value) * 100 / sum(sales), 2) as 'burn rate (%)'
from clean_data
where year(order_date) = 2012 and order_status = 'Order Finished'
group by product_sub_category, product_category
order by 5
;

-- There are only five sub-category of product that have the burn rate bellow 4.5 %. It
-- shown on the first five rows, they are starting on Rubber Bands to Telephones and
-- Communication. Whereas the Labels have higher 0.02% from the maximum value of
-- expected burn rate by DQLab Store.

-- TASK 05: The number of customers transactions for each year
select year(order_date) as years, count(distinct customer) as 'number of customer'
from clean_data
where order_status = 'Order Finished'
group by 1
;

-- The number of customers isn’t changing significantly overall. But fortunately, we
-- didn’t get a significant decline in customers. We can see that the number of
-- customers tends to be in the values around 580–590.

-- TASK 06:The number of new customers for each year
select *
from clean_data
limit 5
;

select year(first_order) as years, count(customer) as 'new customers'
from(
	select customer, min(order_date) as first_order
    from clean_data
    where order_status = 'Order Finished'
    group by 1
) first
group by 1
;

-- The growth of new customers for each year is decreasing. It gets extreme in 2012
-- that only there 11 new customers. But if we back on the result before (fig.7) the
-- number of customers tends to remain overall. This informs us that many previous
-- customers still back to DQLab Store to do the transaction besides the new customers
-- are decreasing.





