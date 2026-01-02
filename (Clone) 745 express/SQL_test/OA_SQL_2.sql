
select
case
when origin in ('ord') then 'Chicago'
when origin in ('dfw') then 'Texas'
#when origin in ('dfw','iah','hou') then 'Texas'
when origin in ('dca','iad','bwi') then 'Washington DC'
when origin in ('ewr','jfk','lga') then 'New York'
when origin = 'den' then 'Denver'
when origin = 'lax' then 'Los Angeles'
when origin = 'sfo' then 'San Francisco'
else 'OTHER' end as CITY,
case
when marketingairline in ('aa','us') then 'AA'
when marketingairline in ('dl','nw') then 'DL'
when marketingairline in ('wn','fl') then 'WN'
when marketingairline in ('as','vx') then 'AS'
else marketingairline end as CARRIER
  ,LEFT(FlightDate,4) as report_yr
  ,month(CURDATE()-1) as report_month
,case
when marketingairline = operatingairline then 'Mainline'
else 'Express' end as ML_EX_IND
  #MTD
,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  and cancelledflag = 0 then 1 when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  then 1 else 0 end) as D00_Flights
,sum(case when cancelledflag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
    when cancelledflag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  then 1 else 0 end) as Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as A00_Flights

#Yest

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') and cancelledflag = 0 then 1 when flightdate= DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Yest_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as Yest_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as Yest_Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as Yest_A00_Flights

#Date-2

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') and cancelledflag = 0 then 1 when flightdate =DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as DateMinus2_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') then 1 else 0 end) as DateMinus2_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') then 1 else 0 end) as DateMinus2_Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') then 1 else 0 end) as DateMinus2_A00_Flights



  from unitedairlines_prod_custom

where marketingairline in ('AA','US','DL','NW','AS')

AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01')- INTERVAL 1 DAY AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')

  AND marketingairline <> operatingairline
  
group by 1,2,3,4,5

UNION ALL

select
case

WHEN marketingairline IN ('aa','us') THEN
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
when marketingairline in ('aa','us') then 'AA'
when marketingairline in ('dl','nw') then 'DL'
when marketingairline in ('wn','fl') then 'WN'
when marketingairline in ('as','vx') then 'AS'
else marketingairline end as CARRIER
  ,LEFT(FlightDate,4) as report_yr
  ,month(CURDATE()-1) as report_month
,case
when marketingairline = operatingairline then 'Mainline'
else 'Express' end as ML_EX_IND
  #MTD
,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  and cancelledflag = 0 then 1 when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Scheduled_Flights
  
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  then 1 else 0 end) as D00_Flights
,sum(case when cancelledflag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
    when cancelledflag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')  then 1 else 0 end) as Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as A00_Flights

#Yest

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') and cancelledflag = 0 then 1 when flightdate= DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Yest_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as Yest_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as Yest_Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as Yest_A00_Flights

#Date-2

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') and cancelledflag = 0 then 1 when flightdate =DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as DateMinus2_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') then 1 else 0 end) as DateMinus2_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') then 1 else 0 end) as DateMinus2_Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%Y%m%d') then 1 else 0 end) as DateMinus2_A00_Flights




  from unitedairlines_prod_custom

where marketingairline in ('AA','US','DL','NW','AS')
AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01')- INTERVAL 1 DAY AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')
  AND marketingairline <> operatingairline
  
group by 1,2,3,4,5
 