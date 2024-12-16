create database olist;
use  olist;

#KPI 1 Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
#Total orders : Weekday Vs Weekend
#Average payment_value : Weekday Vs Weekend
select * from olist_orders_dataset;
select * from olist_order_payments_dataset;
select 
case 
when dayofweek(order_purchase_timestamp) in (1,7)
then 'Weekend' 
else 'weekday'
end as Daytype,
count(distinct o.order_id) as TotalOrders,
round(avg(op.payment_value)) as AveragePaymentValue
from olist_orders_dataset o
join olist_order_payments_dataset op
On o.order_id=op.order_id
group by Daytype;

#KPI 2 Total Number of Orders with review score 5 and payment type as credit card.
select * from order_reviews_dataset;
select * from olist_order_payments_dataset;
select count(distinct op.order_id ) as No_of_Orders
from olist_order_payments_dataset op
join order_reviews_dataset r
on op.order_id = r.order_id
where r.review_score = 5
and op.payment_type ='credit_card';

#KPI 3 Average number of days taken for order_delivered_customer_date for pet_shop
select * from olist_orders_dataset;
select * from olist_products_dataset;
select * from olist_order_items_dataset;
select product_category_name,
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))) as avg_no_of_days
from olist_orders_dataset o
join olist_order_items_dataset oi
on o.order_id = oi.order_id
join olist_products_dataset op
on op.product_id = oi.product_id
where op.product_category_name ='pet_shop';

#KPI 4 Average price and payment values from customers of sao paulo city
select * from olist_order_items_dataset;
select * from olist_order_payments_dataset;
select * from olist_customers_dataset;
select * from olist_orders_dataset;
select round(avg(oi.price)) as AveragePrice,
round(avg(op.payment_value)) as AveragePaymentValue
from olist_customers_dataset oc
join olist_orders_dataset o
on oc.customer_id = o.customer_id
join olist_order_items_dataset oi
on o.order_id = oi.order_id
join olist_order_payments_dataset op
on o.order_id = op.order_id
where oc.customer_city = 'sao paulo';

#KPI 5 Relationship between shipping days Vs review scores.
#shipping days = order_delivered_customer_date - order_purchase_timestamp
select * from olist_orders_dataset;
select * from order_reviews_dataset;
select 
round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))) 
as AverageShippingDays,
review_score
from olist_orders_dataset o
join order_reviews_dataset r
on o.order_id= r.order_id
where order_delivered_customer_date is not null
and order_purchase_timestamp is not null
group by review_score
order by review_score desc;
