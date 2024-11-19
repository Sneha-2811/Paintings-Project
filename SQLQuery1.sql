Use paintings

---Fetch all the paintings which are not displayed on any museums?
select * from work where museum_id is null;

---Are there museuems without any paintings?
select m.name from museum m left join work w on m.museum_id = w.museum_id where  w.museum_id is null

---How many paintings have an asking price of more than their regular price? 
select count(*) as n_paintings from product_size where sale_price > regular_price

---Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size p  where sale_price < (0.5*regular_price) 

---Identify the museums with invalid city information in the given dataset
select * from museum where city  not like '[a-z A-Z]%'

---Museum_Hours table has 1 invalid entry. Identify it and remove it.
select *from museum_hours where [close] like '___:00:PM';

---Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.
select artist_name, nationality,n_paintings from 
(select a.full_name as artist_name, nationality, 
count(1) as n_paintings, rank() over(order by count(1) desc) as rnk
from artist a join work w on a.artist_id = w.artist_id join subject s on s.work_id = w.work_id join 
museum m on m.museum_id =w.museum_id 
 where country != 'USA' and subject = 'Portraits' group by a.full_name ,nationality ) as x where rnk = 1

 ---Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
select museum_name,city,country, n_paintings from
(select m.name as museum_name, m.city as city , m.country as country,  count(1) as n_paintings,
rank() over(order by count(1) desc) as rnk from museum m join work w on 
m.museum_id = w.museum_id group by m.name, m.city , m.country ) as x where rnk < = 5

---Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)
 select  full_name , nationality, n_paintings from  (select full_name , nationality, count(1) as n_paintings , rank() over(order by count(1) desc) as rnk 
from artist a join work w on a.artist_id = w.artist_id group by  full_name, nationality) as x where rnk <= 5

---Which country has the 5th highest no of paintings?
select country, n_paintings from
(select count(1) as n_paintings , country, rank() over(order by count(1) desc) as rnk 
from museum m join work w on m.museum_id = w.museum_id group by country) as s where rnk = 5

---Fetch the top 10 most famous painting subject
select  * from (select subject, count(1) as n_paintings, rank() over(order by count(1) desc) as rnk
from subject s join work w on w.work_id = s.work_id group by subject )x where rnk <= 10

---Identify the artist and the museum where the most expensive and least expensive painting is placed. Display the artist name, sale_price, painting name, museum name, museum city and canvas label
select full_name, 
sale_price, 
painting_name, 
museum_name, 
canvas_label from (select a.full_name as full_name, 
p.sale_price as sale_price, 
w.name as painting_name , 
m.name as museum_name, 
m.city as museum_city , 
c.label as canvas_label , 
row_number() over(order by p.sale_price desc) as rnk, 
row_number() over(order by p.sale_price asc) as rk
from artist a join work w on a.artist_id = w.artist_id 
join product_size p on w.work_id = p.work_id
join museum m on m.museum_id = w.museum_id 
join canvas_size c on c.size_id  = try_cast(p.size_id as bigint))as x where rnk = 1 or rk =1;
