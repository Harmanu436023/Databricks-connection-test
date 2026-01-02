select 
'2019' as Time_period
,count(*) as Total_diverts
 From co_prod_vmdb.vw_rtf_divert d
 Where  d.company_id NOT IN ('bu','ei')
                
              and extract(day  From d.report_dt) between '1' and extract(day  From  current_date - 2)
and extract(month  From d.report_dt) = extract(month  From  current_date - 2)
and extract(year  From d.report_dt) = '2019'
				and  company_id not in ('ua','co') 
				
				union all
select 
'L7D' as Time_period
,count(*) as Total_diverts
 From co_prod_vmdb.vw_rtf_divert d
 Where  d.company_id NOT IN ('bu','ei')
                
                AND d.report_dt between  current_date - 8 and  current_date - 2
				and  company_id not in ('ua','co') 