--Identify the total number of invoices, unique customers, and product categories.

SELECT count (DISTINCT ordernumber) as Total_number_of_invoices,
count (DISTINCT customername) As Unique_customers,
count (DISTINCT productline) as Product_categories
from sales_data_sample

________________________________________________________________________________
----Calculate basic summary statistics for key metrics like total sales amount, 
--average order value, and most frequently purchased items.

--(A)	Total sales amount :
select sum(sales) as Total_sales_amount
from sales_data_sample

--(B)	Average order value :

select avg(Sales_per_order)
from
(
  	select ordernumber, sum(sales) as Sales_per_order
	from sales_data_sample
	group by 1)
 
--(C)	Most frequently purchased items:

--Most frequently purchased items (Product Code):

select productcode, count(productcode) As frequency_of_item_purchase
 from sales_data_sample
 group by 1
 order by 2 DESC

select productcode, sum(quantityordered) As Total_Qty_sold
 from sales_data_sample
 group by 1
 order by 2 DESC
 
 --Most frequently purchased items (Product Line):

select productline, count(productline) As frequency_of_item_purchase
 from sales_data_sample
 group by 1
 order by 2 DESC

select productline, sum(quantityordered) As Total_Qty_sold
 from sales_data_sample
 group by 1
 order by 2 DESC

--(D)	Other statistical calculations :

--Deal size summary :

SELECT dealsize, count(dealsize) as Deal_size_summary
from sales_data_sample
group BY 1
order by 2 DESC

--The Year with highest sales:

select year_id, sum(sales) as Total_sales
from sales_data_sample
group by 1
order by 2 DESC

____________________________________________________________________________________________

----Explore purchase patterns by country or any other relevant demographic information (if available).

--(A)	Total sales per each country, and country with the highest sales.
select country, sum(sales) AS Total_sales
from sales_data_sample
group by 1
order by 2 DESC

--(B)  	The most sold item (product code & product line) in California (CA) state, in terms of Quantity.
select productcode, sum(quantityordered) as Sold_Quantity
from sales_data_sample
where state='CA'
group by 1
order by 2 DESC
limit 2

select productline, sum(quantityordered) as Sold_Quantity
from sales_data_sample
where state='CA'
group by 1
order by 2 DESC
limit 2

--(C)	The Territory with highest number of purchased  “Classic Cars”
SELECT territory, sum(quantityordered) as Num_purchased_units
from sales_data_sample
where productline='Classic Cars'
GROUP by 1
order by 2 DESC


