use sakila;

#1a
select first_name, last_name from actor;

#1b
alter table actor add column name varchar(100);
update actor set name=concat_ws(' ',first_name,last_name);
select * from actor;

#2a
select actor_id, first_name, last_name from actor
where first_name like "Joe";

#2b
select first_name,last_name from actor
where last_name like "%GEN%";

#2c
select last_name,first_name from actor
where last_name like "%LI%";

#2d
select country_id,country from country
where country in ('Afghanistan','Bangladesh','China');

#3a
alter table actor add column description blob;

#3b
alter table actor drop column description;

#4a
select last_name, Count(*) from actor
group by last_name;

#4b
select last_name, count(*) from actor
group by last_name having count(*)>1;

#4c
update actor
set first_name="Harpo", last_name="Williams"
where first_name="Groucho" and last_name="Williams";

#4d
update actor
 set first_name="Groucho", last_name="Williams"
 where first_name="Harpo" and last_name="Williams";
 
#5a
show create table address;

#6a
select
 staff.first_name,staff.last_name,
 address.address
from
	staff
		 join
	address on staff.address_id=address.address_id;
    
#6b
select 
 sum(amount),
 staff.first_name,staff.last_name,staff.staff_id,
 payment.amount,payment.payment_date
from
 staff 
	inner join
 payment 
	on staff.staff_id=payment.staff_id
where payment_date like "2005-08%"
group by staff_id,date_format(payment_date,"%Y-%M");

#6c
select 
	count(actor_id),
    film.title
from
	film
		inner join
	film_actor
		on film.film_id=film_actor.film_id
group by actor_id;

#6d
select
	count(inventory_id),
    film.title
from
	film
		inner join
	inventory
		on film.film_id=inventory.film_id
where film.title="Hunchback Impossible"
group by inventory.film_id;

#6e
select
    customer.last_name,customer.first_name,
    sum(amount)
from
	customer
		join
	payment
		on payment.customer_id=customer.customer_id
group by payment.customer_id
order by last_name;

#7a
select * from film;
select * from language;
select title 
from film
where 
	title like "K%"
    or 
    title like "Q%" 
    and 
    language_id in
		(select language_id 
		from language
        where name="English");

#7b
select first_name, last_name
from actor
where actor_id in
	(select actor_id
    from film_actor
    where film_id in
		(select film_id
        from film
        where title="Alone Trip"));
        
#7c
select * from city;#city_id, country_id
select * from country; #country_id,country
select * from customer;#address_id, email,customer_id
select * from address;#address_id,city_id

select
	country.country, customer.email
from 
	country,
    customer,
    city,
    address
where
	address.address_id=customer.customer_id
    and
    city.city_id=address.city_id
    and
    country.country_id=city.country_id
    and
    country.country='Canada';

#7d
select * from category;#name, category_id
select * from film_category; #film_id,category_id
select * from film; #title, film_id

select
	film.title, category.name
from
	category,film_category,film
where
	category.name="Family"
    and
    category.category_id=film_category.category_id
    and
    film_category.film_id=film.film_id;
    
#7e

select * from rental;#rental_id, inventory_id
select * from inventory;#inventory_id, film_id
select * from film;# film_id,title

select
	film.title, count(rental.rental_id)
from
	rental, inventory, film
where
	rental.inventory_id=inventory.inventory_id
    and
    inventory.film_id=film.film_id
group by
	rental.inventory_id
order by
	count(rental.rental_id) DESC;
    
#7f
select * from store;#store_id
select * from rental;# rental_id, inventory_id,customer_id
select * from inventory; #inventory_id, store_id
select * from payment; #rental_id, amount

select
	store.store_id, sum(payment.amount)
from
	store,rental,payment, inventory
where
	store.store_id=inventory.store_id
    and
    inventory.inventory_id=rental.inventory_id
    and
    rental.rental_id=payment.rental_id
group by
	store_id;
    
#7g
select * from store; # store_id, address_id
select * from address; # address_id, city_id
select * from city; # city_id, city, country_id
select * from country; # country_id, country

select
	store.store_id, city.city, country.country
from
	store
join
	address on store.address_id=address.address_id
join
	city on city.city_id = address.city_id
join
	country on country.country_id = city.country_id;
    
#7h
select * from category; # category_id, name
select * from film_category; # film_id, category_id
select * from inventory; # film_id, inventory_id
select * from rental; # rental_id, inventory_id
select * from payment; # rental_id, amount

select 
	c.name, sum(p.amount)
from
	category c
join
	film_category f on c.category_id=f.category_id
join
	inventory i on i.film_id=f.film_id
join
	rental r on r.inventory_id=i.inventory_id
join 
	payment p on p.rental_id=r.rental_id
group by
	c.name
order by
	sum(p.amount) DESC limit 5;


# 8a

create view top_genre as (select 
	c.name, sum(p.amount)
from
	category c
join
	film_category f on c.category_id=f.category_id
join
	inventory i on i.film_id=f.film_id
join
	rental r on r.inventory_id=i.inventory_id
join 
	payment p on p.rental_id=r.rental_id
group by
	c.name
order by
	sum(p.amount) DESC limit 5);

#8b    
select * from top_genre;

#8c
drop view top_genre;