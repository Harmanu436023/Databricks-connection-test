
select
case
when origin in ('ord','mdw') then 'Chicago'
when origin in ('dfw','iah','hou') then 'Texas'
when origin in ('dca','iad','bwi') then 'Washington DC'
when origin in ('ewr','jfk','lga') then 'New York'
when origin = 'den' then 'Denver'
when origin = 'lax' then 'Los Angeles'
when origin = 'sfo' then 'San Francisco'
else 'OTHER' end as CITY,
case
when marketingairline in ('aa') then 'AA'
when marketingairline in ('dl','nw') then 'DL'
when marketingairline in ('wn','fl') then 'WN'
when marketingairline in ('as','vx') then 'AS'
else marketingairline end as CARRIER
,LEFT(FlightDate,4) as report_yr
  ,SUBSTR(FlightDate, 5, 2) as report_month
,case
when marketingairline = operatingairline then 'Mainline'
else 'Express' end as ML_EX_IND,
  count(origin) as Scheduled_Flights
  ,sum(case when DepVariance <= 0  and CancelledFlag = 0 then 1 else 0 end) as D00_Flights
  ,sum(case when cancelledflag <> 1 then 1 else 0 end) as Completed_Flights
  ,sum(case when arrvariance <= 0 and DivertedFlag <> 1 then 1 else 0 end) as A00_Flights
  ,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_Scheduled_Flights
  ,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_D00_Flights
  ,sum(case when cancelledflag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_Completed_Flights
  ,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_A00_Flights


  ,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_Scheduled_Flights
  ,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_D00_Flights
  ,sum(case when cancelledflag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_Completed_Flights
  ,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_A00_Flights



  from unitedairlines_prod

where 
/*marketingairline in ('AA','DL','NW','AS')*/
marketingairline in ('DL','dl','NW','nw','AA','AS')

AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')

  AND marketingairline <> operatingairline
group by 1,2,3,4,5

UNION ALL

select
case

WHEN marketingairline IN ('aa') THEN
     CASE
        WHEN origin NOT IN ('CLT', 'MIA','PHX','DCA','ORD','PHL','DFW' ) THEN 'LINE'
     END
WHEN marketingairline IN ('dl','nw') THEN
     CASE
        WHEN origin NOT IN ('ATL', 'DTW','LAX','JFK','LGA','MSP','SLC','SEA' ) THEN 'LINE'
     END
WHEN marketingairline IN ('ua','co') THEN     
     CASE
        WHEN origin NOT IN ('SFO', 'LAX','DEN','IAH','ORD','EWR','IAD' ) THEN 'LINE'
     END
WHEN marketingairline IN ('as','vx') THEN     
     CASE
        WHEN origin NOT IN ('ANC', 'SEA','LAX','SFO','PDX') THEN 'LINE'
     END	 
else 'OTHER' end as CITY,
case
when marketingairline in ('aa') then 'AA'
when marketingairline in ('dl','nw') then 'DL'
when marketingairline in ('wn','fl') then 'WN'
when marketingairline in ('as','vx') then 'AS'
else marketingairline end as CARRIER

  ,LEFT(FlightDate,4) as report_yr
  ,SUBSTR(FlightDate, 5, 2) as report_month
,case
when marketingairline = operatingairline then 'Mainline'
else 'Express' end as ML_EX_IND,
  count(origin) as Scheduled_Flights
  ,sum(case when DepVariance <= 0  and CancelledFlag = 0 then 1 else 0 end) as D00_Flights
  ,sum(case when cancelledflag <> 1 then 1 else 0 end) as Completed_Flights
  ,sum(case when arrvariance <= 0 and DivertedFlag <> 1 then 1 else 0 end) as A00_Flights
  ,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_Scheduled_Flights
  ,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_D00_Flights
  ,sum(case when cancelledflag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_Completed_Flights
  ,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_A00_Flights


  ,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_Scheduled_Flights
  ,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_D00_Flights
  ,sum(case when cancelledflag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_Completed_Flights
  ,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') then 1 else 0 end) as LWMinus1_A00_Flights



  from unitedairlines_prod

where 
/*marketingairline in ('AA','DL','NW','AS')*/
marketingairline in ('DL','dl','NW','nw','AA','AS')
AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')
  AND marketingairline <> operatingairline
group by 1,2,3,4,5
