--Who is the senior most employee based on job title?

select * from employee
order by levels desc
LIMIT 1

--Which countries have the most Invoices?

select billing_country , count(*) as total_invoices
 from invoice
 group by billing_country
order by total_invoices desc
limit 5

--What are top 3 values of total invoice

select * from invoice
order by total desc
limit 3


--Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals

SELECT Billing_city, sum(total) as best_city
FROM invoice
group by billing_city 
order by best_city desc
limit 1

--Who is the best customer? The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money

select * from invoice

select * from customer


select c.first_name, c.last_name, c.customer_id, (sum(i.total)) as total
from customer c
join invoice i
on c.customer_id = i.customer_id
group by  c.first_name, c.last_name, c.customer_id
order by total desc
limit 1


--Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A

select distinct c.first_name, c.last_name, c.email
from customer c
join invoice i
on c.customer_id = i.customer_id
join invoice_line il
on i.invoice_id = il.invoice_id
where track_id in	(
		select track_id from track t
 						join genre g 
						 on t.genre_id = g.genre_id
						 where g.name like 'Rock'
						)
order by email asc


--Let's invite the artists who have written the most rock music in our dataset. Write a query that returns the Artist name and total track count of the top 10 rock bands

select ar.artist_id, ar.name, count(ar.artist_id) as total_no
from track t
join album al on al.album_id = t.album_id
join artist ar on ar.artist_id = al.artist_id
join genre g on g.genre_id = t.genre_id
group by ar.artist_id
order by total_no desc
limit 10



--Return all the track names that have a song length longer than the average song length. Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first
select * from track

select name, milliseconds 
from track
where milliseconds > (select avg(milliseconds) 
								from track)
order by milliseconds desc

--Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent

with best_selling as
(

select a.artist_id, a.name as artist_name, sum(il.unit_price*il.quantity) as total_sales
from invoice_line il
join track t on t.track_id = il.track_id
join album al on al.album_id = t.album_id
join artist a on a.artist_id = al.artist_id
group by a.artist_id
order by total_sales desc
limit 1
)



select c.customer_id, c.first_name,c.last_name, bsa.artist_name, 
sum(il.unit_price*il.quantity) as total_sales
from invoice_line il

join invoice i on i.invoice_id = il.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling bsa on bsa.artist_id = alb.artist_id 


group by 1,2,3,4
order by total_sales desc


--We want to find out the most popular music Genre for each country. We determine the
--most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum
--number of purchases is shared return all Genres

with total_sales as
(
select distinct i.billing_country, g.name as genre_name, g.genre_id, sum(i.total) as total_sales
from invoice i
join invoice_line il on i.invoice_id = il.invoice_id
join track t on t.track_id = il.track_id
join genre g on g.genre_id = t.genre_id
group by 1,2,3
order by total_sales desc
)




select distinct total_sales.billing_country,  total_sales.genre_name,  count(inl.quantity) as total_count 
from invoice_line inl
join track t on t.track_id = inl.track_id
join genre g on t.genre_id = g.genre_id
join total_sales on total_sales.genre_name = g.name
group by 1,2
order by total_count


--Write a query that determines the customer that has spent the most on music for each
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all
--customers who spent this amount

WITH RECURSIVE 
	customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	country_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customter_with_country
		GROUP BY billing_country)

SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
FROM customter_with_country cc
JOIN country_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;




























