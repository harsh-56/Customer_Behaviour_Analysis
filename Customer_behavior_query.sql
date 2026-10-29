select * from Customers

--Q1. What is the total revenue generted by male Vs Female customers?

Select gender, SUM(purchase_amount) as revenue
from Customers
group by gender

--Q2. Which customers used a discount but still spend more than the average purchase amount ?

select customer_id, purchase_amount
from customers
where discount_applied = 'Yes'and 
Purchase_amount >=
(select Avg(purchase_amount) from customers)


-- Q3. Which are the top 5 products with the highest average review rating?
select top 5
		item_purchased, round(avg(review_rating),2) as 'Average Product Rating'
from customers
group by item_Purchased
order by avg(review_rating) desc

--Q4. Compare the average Purchase Amounts between Standard and Express Shipping. 
 
 select shipping_type,
 Avg(purchase_amount)
 from customers
 where shipping_type in ('standard','Express')
 group by shipping_type


--Q5. Do subscribed customers spend more? Compare average spend and total revenue 
--between subscribers and non-subscribers.
 
 select subscription_status,
 COUNT(customer_id) as total_customers,
 round(AVG(purchase_amount),2) as Avg_spend,
 sum(purchase_amount) as total_Spend
 from customers
 group by subscription_status
 order by total_Spend,Avg_spend

--Q6. Which 5 products have the highest percentage of purchases with discounts applied?

Select 
	Top 5 
		item_purchased,
Round( 100 * 
	sum(
		case 
			when discount_applied = 'Yes' Then 1 
			else 0
			End
		)/COUNT(*),2
	)as discount_rate
from customers
group by item_purchased
order by discount_rate

Select * from customers

--Q7. Segment customers into New, Returning, and Loyal based on their total 
-- number of previous purchases, and show the count of each segment. 

With Customer_type as(
	select customer_id,previous_purchases,
	case
		WHEN previous_purchases = 1 THEN 'New'
        WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
		Else 'Loyal'
    END AS customer_segment 
	from customers
)

Select customer_segment,COUNT(*) as "number of customers"
from customer_type
group by customer_segment

--Q8. What are the top 3 most purchased products within each category? 

with item_counts as
(
	select category,
	item_purchased,
	count(Customer_id) as Total_orders,
	Row_number() over(partition by category order by count(customer_id) desc) as item_Rank
	from customers
	group by item_purchased,category
)
select item_rank,category,item_Purchased,total_orders
from item_counts
where item_rank <= 3

--Q9. Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?

select subscription_status,
COUNT(customer_id) as Repeat_buyers
from customers
where previous_purchases > 5 
group by subscription_status


--Q10. What is the revenue contribution of each age group? 

Select age_group,
sum(purchase_amount) as  Total_revenue
from customers
group by age_group
order by total_revenue desc