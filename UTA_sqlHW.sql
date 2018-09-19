USE sakila;

-- 1a
select first_name, last_name from actor;

-- 1b
select upper(concat(first_name,' ', last_name)) as 'Actor Name' from actor;

-- 2a
select actor_id, first_name, last_name from actor where first_name = 'Joe';

-- 2b
select first_name, last_name from actor where last_name like '%GEN%';

-- 2c
select last_name, first_name from actor where last_name like '%LI%' order by last_name, first_name;

-- 2d
select country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
alter table actor
add description BLOB;

-- 3b
alter table actor
drop column description;

-- 4a
select last_name, count(last_name) as 'last_name_cnt' from actor group by last_name;

-- 4b
select last_name, count(last_name) as 'last_name_cnt' from actor group by last_name having count(last_name) >= 2;

-- 4c
update actor set first_name = 'HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
select * from actor where last_name = 'WILLIAMS';

-- 4d
update actor set first_name = 'GROUCHO' where first_name = 'HARPO';

-- 5a
show create table address;

-- 6a
select first_name, last_name, address
from staff
inner join address on staff.address_id = address.address_id;

-- 6b
select first_name, last_name, sum(amount) as 'total_amount'
from payment 
inner join staff on staff.staff_id = payment.staff_id
where payment_date like '2005-08%'
group by first_name;

-- 6c
select title, count(actor_id) as 'no. of actors'
from film
inner join film_actor on film.film_id = film_actor.film_id
group by title;

-- 6d
select count(inventory_id) as 'copies of film'
from inventory
inner join film on inventory.film_id = film.film_id
where film.title = 'Hunchback Impossible';

-- 6e
select first_name, last_name, sum(amount) as 'total amount paid'
from payment
join customer on customer.customer_id = payment.customer_id
group by customer.first_name
order by last_name;

-- 7a
select title
from film
where language_id in
	(
    select language_id
    from language
    where name = 'English'
    )
and title like 'K%' or title like 'Q%'
;

-- 7b
select first_name, last_name
from actor
where actor_id in
	(
    select actor_id
    from film_actor
    where film_id in
		(
        select film_id
        from film
        where title = 'Alone Trip'
        )
    )
;

-- 7c

/*select customer.first_name, customer.last_name, customer.email
from customer.address_id c
	join address.address_id a
		on a.address_id = c.address_id
	join city
		on address.city_id = city.city_id
	join country
		on city.country_id = country.country_id
        where country.country_id = 'Canada';*/

select first_name, last_name, email
from customer
where address_id in
	(
    select address_id
	from city
	where city_id in
		(
		select city_id
		from city
		where country_id in
			(
			select country_id
			from country
			where country = 'Canada'
			)
		)
	)
;

-- 7d
select title
from film
where film_id in
	(
    select film_id
    from film_category
    where category_id in
		(
        select category_id
        from category
        where name = 'family'
        )
    )
;

-- 7e
select title, count(rental.rental_id) as 'rental_count'
from film
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
group by film.title
order by rental_count DESC;

-- 7f
select store.store_id, sum(payment.amount)
from store
inner join staff on staff.store_id = store.store_id
inner join rental on rental.staff_id = staff.staff_id
inner join payment on payment.rental_id = rental.rental_id
group by store_id;

-- 7g
select store.store_id, city.city, country.country
from store
inner join address on store.address_id = address.address_id
inner join city on city.city_id = address.city_id
inner join country on country.country_id = city.country_id;

-- 7h
select category.name, sum(payment.amount) as 'gross_revenue'
from payment
inner join rental on rental.rental_id = payment.rental_id
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film_category on film_category.film_id = inventory.film_id
inner join category on category.category_id = film_category.category_id
group by category.name
order by gross_revenue DESC
limit 5;

-- 8a
create view top_five_genres as
select category.name, sum(payment.amount) as 'gross_revenue'
from payment
inner join rental on rental.rental_id = payment.rental_id
inner join inventory on inventory.inventory_id = rental.inventory_id
inner join film_category on film_category.film_id = inventory.film_id
inner join category on category.category_id = film_category.category_id
group by category.name
order by gross_revenue DESC
limit 5;

-- 8b
select * from top_five_genres;

-- 8c
drop view top_five_genres;