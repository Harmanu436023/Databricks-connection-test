Select City as Station, level1 as Timeframe,
Metric as Metric,
UA AS UAX,
AA as AAX,
DL as DLX,
Alaska AS ASX,
C5,
G7,
OO,
YV,
YX,
ZW
 From
(
Select *,
case when City like '%System%' then 1
when City like '%Chicago%' then 2
when City like '%New York%' then 3
when city like '%Washington DC%' then 4
when city like '%Texas%' then 5
when city like '%Los Angeles%' then 6
when city like '%Denver%' then 7
when city like '%San Francisco%' then 8
when city like '%Domestic Airports%' then 9
when city like '%International Airports%' then 10 else 11 end as rank1,
case when level1 like '%Yesterday%' then 1
when level1 like '%MTD%' then 2
when level1 like '%YTD%' then 3 else 4 END AS rank2,
case when metric like 'STAR CD00%' then 1
when metric like '%Inbound STAR CD00%' then 2
when metric like '%D0C%' then 3 else 4 end as rank3
 From
(
select case when city like '%Line Dom%' then 'Domestic Airports'
when city like '%Line Int%' then 'International Airports'
else city end as city,
case when level1 LIKE '%Today%' then 'Yesterday' else level1 end as Level1,
case when metric in ('STI') THEN 'Inbound STAR CD00'
	 when metric in ('STA') THEN 'STAR CD00'
	 when metric in ('D0C') then 'CD00' ELSE metric end as metric,
sum(case when level2='AA' THEN values1 else null end) as AA,
sum(case when level2='DL' THEN values1 else null end) as DL,
sum(case when level2 in ('UAX','UAX CD00') THEN values1 else null end) as UA,
sum(case when level2 in ('AS', 'AS CD00') THEN values1 else null end) as Alaska,
sum(case when level2 IN ('C5', 'C5 CD00') THEN values1 else null end) as C5,
sum(case when level2 IN ('G7','G7 CD00') THEN values1 else null end) as G7,
sum(case when level2 IN ('OO', 'OO CD00') THEN values1 else null end) as OO,
sum(case when level2 IN ('YV', 'YV CD00') THEN values1 else null end) as YV,
sum(case when level2 IN ('YX' , 'YX CD00') THEN values1 else null end) as YX,
sum(case when level2 IN ('ZW', 'ZW CD00') THEN values1 else null end) as ZW
 --select distinct Level1,city 
 from OPFL_DEPT_DB.vw_UAX_Daily_Report
 Where case when city in ('System') AND METRIC IN ('STA','D0C') THEN 1
            when city like ('%Line Dom%') AND METRIC IN ('STA','D0C') THEN 1
            when city like ('%Line Int%') AND METRIC IN ('STA','D0C') THEN 1
            when city in ('Chicago','New York','Washington DC','Texas','Los Angeles','Denver','San Francisco') AND METRIC IN ('STI','D0C') THEN 1 ELSE 0 END = 1
Group by 1,2,3
)
)final1
order by rank1,rank3,rank2
