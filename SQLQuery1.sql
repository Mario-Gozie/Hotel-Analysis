-- we have a total of five tables tables for different years so we need to union them.
-- three contain hotel info based on years 2018,2019,2020.
-- the other two are meal cost and market segment table
--select * from meal_cost$

--select * from market_segment$

-- so I was asked if our revenue is growing per year. 
-- we do not have a revenue column so we need to sum the day and night, 
--then mutiply by the daily rate by night,discount from the market segment table and the cost for type of meal individuals ate.

with hotel_data as(
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$'])

select H.hotel, H.arrival_date_year, H.arrival_date_month,
H.stays_in_week_nights,H.stays_in_weekend_nights,A.meal,format(cost,'c') as Meal_cost,Isnull(H.country, 'No Country given') as country,
M.market_segment,format(H.adr,'c') as daily_rate_per_night, H.required_car_parking_spaces,
format (round((H.stays_in_week_nights + H.stays_in_weekend_nights) * H.adr* M.Discount *Cost,2), 'c')
as Revenue
from hotel_data as H
left join market_segment$ as M
on M.market_segment = H.market_segment
left join meal_cost$ as A 
on A.meal = H.meal;
go

with hotel_data as(
select * from dbo.['2018$']
union
select * from dbo.['2019$']
union
select * from dbo.['2020$']),

Revenue_per_year as (select H.hotel, H.arrival_date_year, H.arrival_date_month,
H.stays_in_week_nights,H.stays_in_weekend_nights,A.meal,cost as Meal_cost,Isnull(H.country, 'No Country given') as country,
M.market_segment,format(H.adr,'c') as daily_rate_per_night, H.required_car_parking_spaces,
round((H.stays_in_week_nights + H.stays_in_weekend_nights) * H.adr* M.Discount *Cost,2)
as Revenue
from hotel_data as H
left join market_segment$ as M
on M.market_segment = H.market_segment
left join meal_cost$ as A 
on A.meal = H.meal)

select arrival_date_year, sum(Revenue) as Total_Revenue 
from Revenue_per_year
group by arrival_date_year
order by Total_Revenue desc;


