Select '2019' as Time_period,
sum(
		case 
			when divert_status = 'TERM' then 1 
			else 0 end) as divert_unrecovered,
sum(
		case 
			when divert_status = 'CONT' then 1 
			else 0 end) as divert_recovered
 From	co_prod_vmdb.rtf_flt_leg_operation_Ss r
 Where	r.company_id not in ('bu',
		'ei') 
	and  r.company_id not in ('ua','co') 
	and r.return_type_cd = ''
	and r.report_day between '1' and extract(day  From  current_date - 1)
	and r.report_month = extract(month From current_date )
	and r.report_year = '2019'
union all 
Select 'L7D' as Time_period,
sum(
		case 
			when divert_status = 'TERM' then 1 
			else 0 end) as divert_unrecovered,
sum(
		case 
			when divert_status = 'CONT' then 1 
			else 0 end) as divert_recovered
 From	co_prod_vmdb.rtf_flt_leg_operation_Ss r
 Where	r.company_id not in ('bu',
		'ei') 
	and  r.company_id not in ('ua','co') 
	and r.return_type_cd = ''
	and r.report_dt between  current_date - 7 and  current_date - 1