
select
  case when marketingairline in ('AA') then 'AA' when marketingairline in ('DL','NW') then 'DL' when marketingairline in ('WN','FL') then 'WN' else marketingairline end as carrier
  ,LEFT(FlightDate,4) as report_yr
  ,LEFT(FlightDate,4) as report_yr1
  ,case when marketingairline <> operatingairline then 'Express' else 'Mainline' end as ml_ex_ind
  ,count(origin) as Scheduled_Flights
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
,sum(case when arrvariance <= 14 and DivertedFlag <> 1  and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 7 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d') then 1 else 0 end) as LW_A00_Flights


  from unitedairlines_prod

where marketingairline in ('AA','DL','NW')
  AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 14 DAY, '%Y%m%d') AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')
  AND marketingairline <> operatingairline
group by 1,1,3,4
order by 1 asc





