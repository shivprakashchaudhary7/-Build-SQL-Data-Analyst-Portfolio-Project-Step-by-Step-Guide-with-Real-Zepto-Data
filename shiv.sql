create table zepto (
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER,
sku_id integer
);

drop table if exists zepto;

--count of rows
select count(*) from zepto;
--sample data
SELECT * FROM zepto
LIMIT 10;
--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;
--product names present multiple times
SELECT name, COUNT(sku_id) AS "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;
--addng the new column and using the alter 
alter table zepto
add sku INTEGER ;

-- rename the column 
alter table zepto
rename column sku to sku_id ;
-- run the command 
select * from zepto;
-- delete the column 
alter table zepto 
drop  column sku_id;
  
-- Data Cleaniong 
--Product with zero
select * from zepto
where mrp=0 or discountedsellingprice=0;

delete from zepto 
where mrp=0;

-- convert from paisa to rupees
 update zepto
 set mrp=mrp/100.0,
 discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedSellingPrice FROM zepto; 

--Data Analysis 
--Q1 Find the top 10 best-value products based on the discount percentage.

select distinct name , mrp,  discountpercent 
from zepto
order by discountpercent desc 
limit 10;

--Q2 What are the Products with High MRP but Out of Stock

select distinct name , mrp
from zepto 
where outofstock = true and mrp>300
order by mrp desc;

-- Q5 Identify the top 5 categories offering the highest average discount percentage.

select category ,
round (avg(discountpercent),2)as avg_discount
from zepto
group by category 
order by avg_discount desc
limit 5;

--Q3.Calculate Estimated Revenue for each category

SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4 Find all products where MRP is greater than ₹500 and discount is less than 10%.

select distinct name , mrp , discountpercent
from zepto
where mrp >500 and discountpercent < 10 
order by mrp desc , 
discountpercent desc;

-- Q6 Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice/weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram;  

--Q7 .Group the products into categories like Low, Medium, Bulk.

SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'Low'
	WHEN weightInGms < 5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;