Select 
CARRIER,
sum(sched_seat - actual_seat)*1.000/nullif(sum(sched_seat),0) as Seat_CNXL_Rate
from
(


Select
case
when marketingairline in ('aa','us') then 'American'
when marketingairline in ('dl','nw') then 'Delta'
when marketingairline in ('NK') then 'Spirit'
when marketingairline in ('F9') then 'Frontier'
when marketingairline in ('as','vx') then 'Alaska'
when marketingairline in ('B6') then 'JetBlue'
when marketingairline in ('WN') then 'Southwest'
else marketingairline end as CARRIER,
 sum(case when  cancelledflag = 0 then FirstSeatCount+	BusSeatCount +EcoSeatCount
 when cancelledflag = 1 AND CXLTIMESTAMP >0 then FirstSeatCount+BusSeatCount +EcoSeatCount else 0 end) as sched_seat,
sum(case
         when cancelledflag = 0  and marketingairline in ('as','vx') and origin = 'SFO' and diversionairport in ('SJC','OAK') then 0 
		   when cancelledflag = 0 then FirstSeatCount+	BusSeatCount +EcoSeatCount
        else 0 end) as actual_seat     
from unitedairlines_prod_custom_realtime
Where  
marketingairline  in ('aa','us','dl','nw')
AND flightdate between DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m01') and DATE_FORMAT(CURDATE() - INTERVAL 1 DAY, '%Y%m%d')
AND marketingairline <> operatingairline
GROUP BY 1
)T
GROUP by 1