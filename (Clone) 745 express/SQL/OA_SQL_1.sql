
select
case when marketingairline in ('AA') then 'AA' when marketingairline in ('DL','NW') then 'DL' when marketingairline in ('WN','FL') then 'WN' else marketingairline end as carrier
,LEFT(FlightDate,4) as report_yr
,month(CURDATE()-1) as report_month
,case when marketingairline <> operatingairline then 'Express' else 'Mainline' end as ml_ex_ind


#MTD
,sum(case when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')  and cancelledflag = 0 then 1 when flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')  and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')  then 1 else 0 end) as D00_Flights
,sum(case when cancelledflag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')  and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
    when cancelledflag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')  then 1 else 0 end) as Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as A00_Flights
,sum(case when arrvariance <= 14 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as A14_Flights
#Yest

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') and cancelledflag = 0 then 1 when flightdate= DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Yest_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as Yest_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as Yest_Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as Yest_A00_Flights
,sum(case when arrvariance <= 14 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as Yest_A14_Flights

#Date-2

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') and cancelledflag = 0 then 1 when flightdate =DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as DateMinus2_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') then 1 else 0 end) as DateMinus2_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') then 1 else 0 end) as DateMinus2_Completed_Flights
,sum(case when arrvariance <= 0 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') then 1 else 0 end) as DateMinus2_A00_Flights
,sum(case when arrvariance <= 14 and DivertedFlag <> 1  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 2 DAY, '%%Y%%m%%d') then 1 else 0 end) as DateMinus2_A14_Flights

from unitedairlines_prod_custom

where marketingairline in ('AA','DL','NW')
AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01')- INTERVAL 1 DAY AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')
AND marketingairline <> operatingairline

group by 1,2,3,4