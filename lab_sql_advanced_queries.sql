## 1 .List each pair of actors that have worked together.

select * from actor;
select * from film_actor;

select a1.actor_id, concat(an1.first_name,' ',an1.last_name) as actor_1, a2.actor_id, concat(an2.first_name,' ',an2.last_name) as actor_2 from sakila.film_actor as a1
join sakila.film_actor as a2 on a2.film_id = a1.film_id and a1.actor_id < a2.actor_id
join sakila.actor as an1 on an1.actor_id = a1.actor_id
join sakila.actor as an2 on an2.actor_id = a2.actor_id
group by a1.actor_id, a2.actor_id
order by a1.actor_id, a2.actor_id;


## 2.For each film, list actor that has acted in more films.

select concat(a.first_name,' ',a.last_name),f.title, sub2.total_films_acted from (
	select fa.actor_id, fa.film_id, sub1.total_films_acted,rank() over (partition by film_id order by sub1.total_films_acted desc) as rank_films_actor
	from sakila.film_actor as fa
	join (
		select actor_id, count(*) as total_films_acted 
		from sakila.film_actor
		group by actor_id
		) as sub1 on fa.actor_id = sub1.actor_id) as sub2
join sakila.actor as a using(actor_id)
join sakila.film as f using(film_id)
where rank_films_actor = 1;