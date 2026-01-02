select 
'United' as CARRIER,
SUM(CASE 
				when r.ex_company_id <> ' ' and r.company_id not in ('bu', 'ei', 'af', 'vs')   then 0
				when  r.sch_cd='s' and r.cnxl_cd='c' and r.cnxl_reason_cd not in ('nt')
				  and r.cnxl_reason_cd not like 'z%' and r.divert_reason_cd = ' '
				  and r.company_id not in ('bu', 'ei', 'af', 'vs') 
				  then SCH_CAP else 0 end )*1.000/nullif(sum( SCH_CAP),0) as Seat_CNXL_Rate
 From CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
 LEFT JOIN CO_PROD_VMDB.RTF_CNXL_TYPE C  on R.CNXL_REASON_CD=C.CNXL_REASON_CD
 Where 
r.report_day between '1' and '31'
and r.report_month = extract(month From current_date )
and r.report_year = '2019'
AND R.COMPANY_ID NOT IN ('UA','CO')
AND R.COMPANY_ID NOT IN ('BU','EI')
AND R.SCH_CD IN ('S', 'U')
AND TRIM(R.RETURN_TYPE_CD) = ''