drop table if exists zepto
;

create table zepto(
	sku_id SERIAL primary key,
	category varchar(120),
	name varchar(150) not null,
	mrp numeric(8, 2),
	discountPercent numeric(5, 2),
	availableQuantity integer,
	discountedSellingPrice numeric(8, 2),
	weigntInGms	integer,
	outOfStock boolean,
	quantity integer
);


-- DATA EXPLORATION
select count(*)
from zepto
;

-- sample data look
select *
from zepto
limit 10
;

-- looking for null values
select *
from zepto
where name is null
or
category is null
or
mrp is null
or
discountPercent is null
or
discountedSellingPrice is null
or
weigntInGms is null
or
availableQuantity is null
or
outOfStock is null
or
quantity is null
;

ALTER TABLE zepto
RENAME COLUMN weigntInGms to weightInGms;

select *
from zepto
limit 10
;

-- product categories in data
select distinct category
from zepto
order by category
; --total 14 categories 

-- products in stock vs out of stock
select outOfStock, count(sku_id)
from zepto
group by outOfStock
; -- 3279 products available and 453 products out of stock

-- product names prresent multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc
;

-- DATA CLEANING
-- products having proce 0
select *
from zepto
where mrp = 0 or discountedSellingPrice = 0
; -- delete if present

delete from zepto
where mrp = 0
;

-- in the data, the unit of mrp and discountedSellingPrice is in 'paise', so convert it to rupee by dividing by 100
-- converting paise to rupee
update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0
;

select mrp, discountedSellingPrice
from zepto
;


-- Business Insights (Questions)
-- Q1. Find the top 10 best-value products based on the discount percentage.

select distinct name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10
;

-- Q2.What are the Products with High MRP but Out of Stock
select *
from zepto
;

select distinct name, mrp
from zepto
where outOfStock = 'true'
order by mrp desc
;

-- Q3.Calculate Estimated Revenue for each category
select 
		category,
		sum(discountedSellingPrice * availableQuantity) as total_revenue
from zepto
group by category
order by total_revenue
;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
select distinct name, mrp, discountPercent
from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc
;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
select 
	category,
	round(avg(discountPercent), 2) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5
;

-- Q6. Find the price per gram for products above 100g and sort by best value.
select 
	distinct name, 
	weightInGms, 
	discountedSellingPrice, 
	round(discountedSellingPrice/weightInGms, 2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram
;

--Q7.Group the products into categories like Low, Medium, Bulk.
select distinct name, weightInGms,
case when weightInGms < 1000 then 'low'
	when weightInGms < 5000 then 'medium'
	else 'bulk'
	end as weight_category
from zepto
;

--Q8.What is the Total Inventory Weight Per Category 
select
	category,
	sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight
;

