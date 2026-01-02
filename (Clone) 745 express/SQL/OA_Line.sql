select
case
  when marketingairline in ('aa') and origin not in ('clt','dca','dfw','jfk','lax','lga','mia','ord','phl','phx') and origincountry in ('US') then 'Line Dom'
  when marketingairline in ('aa') and origin not in ('clt','dca','dfw','jfk','lax','lga','mia','ord','phl','phx') and origincountry not in ('US') then 'Line Int'
  when marketingairline in ('dl','nw') and origin not in ('atl','bos','dtw','jfk','lax','lga','msp','sea','slc') and origincountry in ('US') then 'Line Dom'
  when marketingairline in ('dl','nw') and origin not in ('atl','bos','dtw','jfk','lax','lga','msp','sea','slc') and origincountry not in ('US') then 'Line Int'  
else 'OTHER' end as CITY,
case
when marketingairline in ('aa') then 'AA'
when marketingairline in ('dl','nw') then 'DL'
when marketingairline in ('wn') then 'WN'
when marketingairline in ('as','vx') then 'AS'
else marketingairline end as CARRIER,
case
when marketingairline <> operatingairline then 'Mainline'
else 'Express' end as ML_EX_IND

,sum(case when flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') and cancelledflag = 0 then 1 when flightdate= DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') and cancelledflag = 1 AND CXLTIMESTAMP > 0 then 1 else 0 end) as Yest_Scheduled_Flights
,sum(case when DepVariance <= 0  and CancelledFlag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as Yest_D00_Flights
,sum(case when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0
when cancelledflag = 0 and flightdate = DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d') then 1 else 0 end) as Yest_Completed_Flights


from masflightdb_customers_prd.unitedairlines_prod_custom

where
marketingairline in ('aa','wn','dl','nw','b6','as','vx','f9','nk')
AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m01')- INTERVAL 1 DAY AND DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%%Y%%m%%d')
AND marketingairline <> operatingairline
  
group by 1,2,3