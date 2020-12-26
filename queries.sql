## left outer join exercise.
SELECT order_date,order_id,c.first_name as customer, sh.name as shipper, ost.name order_status
FROM ORDERS o
JOIN customers c 
     ON o.customer_id = c.customer_id
LEFT JOIN SHIPPERS sh
	 ON o.SHIPPER_ID = sh.SHIPPER_ID
JOIN order_statuses ost
     on o.status = ost.order_status_id;   
## self join
SELECT e.employee_id, e.first_name as employee , e1.first_name as manager
FROM EMPLOYEES e
left JOIN  EMPLOYEES e1
on e.reports_to = e1.employee_id 
and e1.first_name is null;
#using keyword
SELECT  p.date, c.name as client, amount, pm.name 
from payments p 
JOIN CLIENTS c using (client_id)
JOIN payment_methods pm on p.payment_method = pm.payment_method_id;

#UNION

SELECT customer_id,first_name,points,'Broonze'
FROM CUSTOMERS
WHERE points< 2000
UNION
SELECT customer_id,first_name,points,'Sliver'
FROM CUSTOMERS
WHERE points between 2000 and 3000
UNION
SELECT customer_id,first_name,points,'Gold'
FROM CUSTOMERS
WHERE points > 3000
order by first_name;
#Aggregate Functions( MAX,MIN,AVG,Count)
select 'First Half Of 2019', 
        sum(invoice_total) as total_sales,
        sum(payment_total) as total_payment, 
        sum(invoice_total -  payment_total ) as what_we_expect
FROM invoices
where invoice_date between '2019-01-01' and '2019-06-30'
UNION
select 'Second Half Of 2019', 
        sum(invoice_total) as total_sales,
        sum(payment_total) as total_payment,  
        sum(invoice_total -  payment_total ) as what_we_expect
FROM invoices
where invoice_date between '2019-07-01' and '2019-12-31'
UNION
select 'Total', 
	   sum(invoice_total) as total_sales,
	   sum(payment_total) as total_payment,  
       sum(invoice_total -  payment_total ) as what_we_expect
FROM invoices
where invoice_date between '2019-01-01' and '2019-12-31';

# group by example
SELECT client_id,
       sum(invoice_total) as total_sales
FROM  invoices
group by client_id   
order by total_sales ;

SELECT DATE,PM.NAME AS PAYMENT_METHOD, sum(AMOUNT) as total_amount
FROM PAYMENTS P
JOIN PAYMENT_METHODS PM ON P.PAYMENT_METHOD = PM.PAYMENT_METHOD_ID
group by date,payment_method
order by date;

SELECT 
      c.customer_id,
      c.first_name,
      sum(oi.quantity * oi.unit_price) as total_amt
from 
customers c
join orders o using (customer_id)
join order_items oi using (order_id)
where state = 'VA' 
group by 
 c.customer_id,
 c.first_name 
having total_amt > 100;
# Roll up
SELECT pm.name, sum(p.amount) as total
from payments p
join payment_methods pm on p.payment_method = pm.payment_method_id
group by pm.name with rollup
order by total;

# Find products that are more expensive than Lettuce (id=3)
SELECT * from products where unit_price > (select unit_price from products where product_id=3);


# find employees who earn more than average.
select * from employees 
where salary > (
               select avg(salary) 
               from employees
);

#Sub Query with in operator 
# find the products that never been ordered.
select * from products where product_id not in (
select distinct(product_id) 
from order_items
);
#find clients without invoices.
select * from clients 
where client_id NOT IN (
  select distinct(client_id) from invoices
);

# using join
select * 
from clients 
left join invoices i using (client_id)
where i.client_id is null;

# select customers who have ordered lettuece(id=3)
select DISTINCT customer_id,first_name,last_name 
from customers 
left join orders o using (customer_id)
join order_items oi using(order_id)
where oi.product_id = 3;

#2nd solution
select customer_id,first_name,last_name
from customers where customer_id in (
  select customer_id 
  from orders 
  join order_items oi using (order_id)
  where oi.product_id = 3
);
# select invoices larger than all invoices of client3
select * from invoices 
where invoice_total >
(select max(invoice_total)
from invoices
where
client_id = 3 );
#Using all
select * from invoices 
where invoice_total >
ALL(select invoice_total
from invoices
where
client_id = 3 );
# select clients with atleast two invoices.
select * from clients
where client_id in (
select client_id
from invoices 
group by client_id
having count(*) >= 2);
# select employees whose salary is above the avarage in their office.(co-related subquery)
select * 
from employees e
where salary > (
select avg(salary)
from employees
where office_id = e.office_id
);
#Get invoices that are larger than the client's average invoice amount.
select * 
from invoices i
where invoice_total > (
select avg(invoice_total) 
from invoices 
where client_id = i.client_id
);
#select the clients that have invoices
select * 
from clients 
where client_id in (
select client_id 
from clients c
join invoices i using (client_id)
where c.client_id = i.client_id
);
#Aleternate
select distinct name,c.client_id, address,city
from clients c
join invoices i on c.client_id = i.client_id
where c.client_id = i.client_id;

#Alternative (corelated sub queries)
select * 
from clients c
where  EXISTS(
select client_id
from invoices 
where client_id = c.client_id
);
# find the products that have never been ordered.
select * 
from products p
where not exists(
select product_id
from order_items
where product_id = p.product_id
);
#Alternative
select *
from products
where product_id not in (
select product_id
from order_items
);











       
       











     
