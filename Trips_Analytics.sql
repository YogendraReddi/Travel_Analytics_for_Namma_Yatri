# Travel Trips Analytics

select * from trips;

select * from trips_details4;

select * from loc;

select * from duration;

select * from payment;


 -- total trips

select count(distinct tripid) from trips_details4;

select tripid,count(tripid) cnt from trips_details4
group by tripid
having count(tripid) >1


-- total drivers

 select * from trips;

select count(distinct driverid) from trips;

-- total earnings

select sum(fare) from trips;

-- total Completed trips

select * from trips_details4;  
select sum(end_ride) from trips_details4;

-- total searches

select sum(searches),sum(searches_got_estimate),sum(searches_for_quotes),sum(searches_got_quotes),
sum(customer_not_cancelled),sum(driver_not_cancelled),sum(otp_entered),sum(end_ride)
from trips_details4;

-- total searches which got estimate
select sum(searches_got_estimate) searches from trips_details4;

-- total searches for quotes
select sum(searches_for_quotes) searches from trips_details4;

-- total searches which got quotes
select sum(searches_got_quotes) searches from trips_details4;

select * from trips;


select * from trips_details4;


-- total driver cancelled
select sum(driver_not_cancelled) searches from trips_details4;

-- total otp entered
select sum(otp_entered) searches from trips_details4;

-- total end ride
select sum(end_ride) searches from trips_details4;
-- average distance per trip

select avg(distance) from trips;


-- average fare per trip

select sum(fare)/count(*) from trips;

-- distance travelled

select sum(distance) from trips;



-- which is the most used payment method 
select a.method from payment a inner join
(select  faremethod, count(tripid) cnt
from trips
group by faremethod
order by count(tripid) desc
limit 1) b
on a.id=b.faremethod;
-- the highest payment was made through which instrument
select a.method from payment a inner join
(select * from trips
order by fare desc limit 1) b
on a.id=b.faremethod;

-- which two locations had the most trip
select * from
(select *, dense_rank() over( order by trip desc) rnk from 
(select loc_from,loc_to, count(distinct tripid) trip
from trips 
group by loc_from,loc_to ) a)b
where rnk = 1;
-- top 5 earning drivers
select * from
(select *, dense_rank() over(order by fare desc) rnk
from
(select  driverid,sum(fare) fare from trips
group by driverid) b) c
where rnk<6;

-- which duration had more trips
select * from
(select *, rank() over(order by cnt desc) rnk from
(select duration, count(distinct tripid) cnt from trips
group by duration) b) c limit 1;

-- which driver , customer pair had more orders
select * from
(select *, rank() over(order by cnt desc) rnk from
(select driverid, custid, count(distinct tripid) cnt from trips
group by driverid, custid) b) c limit 1;

-- search to estimate rate
select * from trips_details4;
 select  sum(searches_got_estimate)*100.0/sum(searches) from trips_details4;
 

-- estimate to search for quote rates
 select  sum(searches_for_quotes)*100.0/sum(searches) from trips_details4;

-- quote acceptance rate

select  sum(searches_got_quotes)*100.0/sum(searches) from trips_details4;
-- quote to booking rate
select  sum(searches_got_quotes)*100.0/sum(searches) from trips_details4;

-- booking cancellation rate
select  sum(cutomer_not_cancelled)*100.0/sum(searches) from trips_details4;

-- conversion rate
select * from trips_details4;
select  sum(customers_not_cancelled)*100.0/sum(searches) from trips_details4;
-- which area got highest trips in which duration
select * from
(select *, rank() over ( partition by loc_from,  order by cnt desc ) rnk from
(select duration,loc_from, count(distinct tripid) cnt from trips
group by duration,loc_from) a)b
where rnk =1;

SELECT * FROM 
(
    SELECT duration, loc_from, COUNT(DISTINCT tripid) AS cnt,
           RANK() OVER (PARTITION BY loc_from ORDER BY COUNT(DISTINCT tripid) DESC) AS rnk
    FROM trips
    GROUP BY duration, loc_from
) AS ranked_trips
WHERE rnk = 1;


-- which area got the highest fares, cancellations,trips,

select * from trips;
select * from trips_details4;
select * from 
 (select *,rank() over(order by fare desc) rnk
from
(select loc_from ,sum(fare) fare from trips
group by loc_from) b ) c
where rnk = 1;

select * from
(select *, rank() over (order by can desc) rnk
from
(select loc_from,count(*) - sum(customer_not_cancelled) can
from trips_details4
group by loc_from)b)c
where rnk =1;

-- which duration got the highest trips and fares
select * from 
 (select *,rank() over(order by fare desc) rnk
from
(select duration ,sum(distinct tripid) fare from trips
group by duration) b ) c
where rnk = 1;
