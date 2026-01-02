select 
r.company_id||'-'||company.company_dscr as "Express Partner"
, r.flt_num as "Flight num"
,r.sch_dprt_sta_cd as "Dep Stn"
,r.sch_arrv_sta_cd as "Arrv Stn"
,r.CNXL_REASON_CD||' - '||cnxl.cnxl_reason_dscr as "Cancel Description"
,r.SCH_FLEET_TYPE_DSCR as "A/C type"
,r.charged_equip_id as Nose
,r.EST_CNXL_PAX_cnt as PBT
,to_char(r.sch_dprt_dtml,'fmMM/fmDD/YYYY HH:MI') as "Sch Dep time (Local)"
,to_char(r.CNXL_DTML,'fmMM/fmDD/YYYY HH:MI') as "Time cancel (Local)"
,CASE 
	WHEN extract(year  From r.CNXL_DTML) <> 0001 
	then
		case when r.CNXL_DTML < r.sch_dprt_dtml 
			THEN '('||cast(left(trim(ltrim(dateadd(seconds,-datediff(second,r.sch_dprt_dtml,r.CNXL_DTML),'1900-01-01 00:00:00'),'1900-01-01') ),5) as VARCHAR(20)) || ')'
			ELSE cast(left(trim(ltrim(dateadd(seconds,datediff(second,r.sch_dprt_dtml,r.CNXL_DTML), '1900-01-01 00:00:00'),'1900-01-01') ),5) AS VARCHAR(20)) 
		end 
	else
	cast(left(trim(dateadd(seconds,datediff(second,r.CNXL_DTML,r.CNXL_DTML), '1900-01-01 00:00:00') ),5) AS VARCHAR(20))
END
as "HH:MM Cnxl (Before)/After Sch dep time"
 
,ex_company_id as "Ex Sec"
 From co_prod_vmdb.rtf_flt_leg_operation_ss r
 LEFT JOIN 
 co_prod_vmdb.cnxl_reason_cd cnxl
on r.CNXL_REASON_CD = cnxl.cnxl_reason_cd
 LEFT JOIN 
co_prod_vmdb.company company
on r.company_id = company.company_id
 Where r.company_id not in ('bu','ei') 
and trim(r.return_type_cd) = ''
and r.sch_cd in ('s','u')
and r.company_id not in ('ua','co')
and r.report_dt = current_date-2
and r.cnxl_cd = 'C'
and r.DIVERT_REASON_CD = ''
order by 1,2,9