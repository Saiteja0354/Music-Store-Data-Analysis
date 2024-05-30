--Question Set1 - Easy
--Q1 Who is the senior most employee based on job title?
select * from employee

select top 1*
from employee
order by levels desc


--Q2 Which countries have the most Invoices?
select * from invoice

select billing_country , count(*) as cnt
from invoice
group by  billing_country
order by cnt desc

--Q3 What are top 3 values of total invoice?select * from invoice

select top 3 total 
from invoice
order by total desc

--Q4 Which city has the best customers? We would like to throw a promotional Music
--Festival in the city we made the most money. Write a query that returns one city that
--has the highest sum of invoice totals. Return both the city name & sum of all invoice
--totalsselect * from invoice

select top 1 billing_city , sum(total) as invoice_total
from invoice 
group by billing_city
order by invoice_total desc

--Q5 Who is the best customer? The customer who has spent the most money will be
--declared the best customer. Write a query that returns the person who has spent the
--most moneyselect * from customer
select * from invoice

select top 1 c.customer_id , sum(i.total) as TotalAmountSpent
from invoice as i
join customer as c
on c.customer_id = i.customer_id
group by c.customer_id 
order by sum(i.total) desc

--Question Set2 - Moderate
--Q1 Write query to return the email, first name, last name, & Genre of all Rock Music
--listeners. Return your list ordered alphabetically by email starting with A

select * from customer
select * from genre


select c.email , c.first_name , c.last_name 
from customer as c 
join invoice as i
on c.customer_id = i.customer_id
join invoice_line as il on il.invoice_id = i.invoice_id
where track_id in (
						SELECT track_id 
						from track as t
						join genre as g on t.genre_id = g.genre_id
						where g.name Like 'Rock'
					) 
AND c.email LIKE 'A%'
order by c.email

--Q2 Let's invite the artists who have written the most rock music in our dataset. Write a
--query that returns the Artist name and total track count of the top 10 rock bands
select * from artist

select top 10 a.name , count(a.artist_id) as Number_of_songs 
from track as t
join album as ab 
on t.album_id = ab.album_id
join artist as a 
on a.artist_id = ab.artist_id
join genre g 
on g.genre_id = t.genre_id
where g.name = 'Rock'
group by  a.name
order by Number_of_songs desc	

--Q3 Return all the track names that have a song length longer than the average song length.
--Return the Name and Milliseconds for each track. Order by the song length with the
--longest songs listed firstselect * from track
select t.name , t.millisecondsfrom track as twhere t.milliseconds > (							select  avg(t.milliseconds) as AverageSongLength
							from track as t
						)
order by t.milliseconds desc

--Question Set3 - Advance

--Q1 Find how much amount spent by each customer on artists? Write a query to return
--customer name, artist name and total spent

select * from artist
select * from invoice_line

WITH best_selling_artist as (
								select top 1 a.artist_id , a.name , 
								sum(il.unit_price*il.quantity) as total_sales
								from invoice_line as il
								join track as t 
								on t.track_id = il.track_id
								join album as ab
								on ab.album_id = t.album_id
								join artist as a
								on a.artist_id = ab.artist_id
								group by a.artist_id , a.name
								order by sum(il.unit_price*il.quantity) desc
							)
select c.first_name , c.last_name , bsa.name ,  sum(il.unit_price*il.quantity) as amount_spend
from invoice as i
join customer as c
on i.customer_id = c.customer_id
join invoice_line as il 
on il.invoice_id = i.invoice_id
join track as t
on t.track_id = il.track_id
join album as ab
on ab.album_id = t.album_id
join artist as a
on a.artist_id = ab.artist_id
join best_selling_artist as bsa on bsa.artist_id = ab.artist_id
group by c.first_name , c.last_name , bsa.name
order by sum(il.unit_price*il.quantity) desc

--Q2 . We want to find out the most popular music Genre for each country. We determine the
--most popular genre as the genre with the highest amount of purchases. Write a query
--that returns each country along with the top Genre. For countries where the maximum
--number of purchases is shared return all Genres
select * from genre
select * from customer



WITH popular_genre as (
						select g.genre_id , g.name , c.country , count(il.quantity) as Purchases , 
						ROW_NUMBER() over(partition by c.country order by  count(il.quantity) desc) as rowno
						from invoice_line as il
						join invoice i 
						on i.invoice_id = il.invoice_id
						join customer c
						on c.customer_id = i.customer_id
						join track as t
						on t.track_id = il.track_id
						join genre as g
						on g.genre_id = t.genre_id
						group by g.genre_id , g.name , c.country 
					)
select * from popular_genre 
where rowno <= 1

--Q3 Write a query that determines the customer that has spent the most on music for each
--country. Write a query that returns the country along with the top customer and how
--much they spent. For countries where the top amount spent is shared, provide all
--customers who spent this amount
select * from customer
select * from invoice



with customer_with_country as (
select c.customer_id , c.first_name , c.last_name , i.billing_country , sum(i.total) as total_spending,
ROW_NUMBER() over(partition by i.billing_country order by sum(i.total) desc) as rowno
from invoice as i 
join customer as c 
on i.customer_id = c.customer_id
group by c.customer_id , c.first_name , c.last_name , i.billing_country
)
select * from customer_with_country
where rowno <= 1

















