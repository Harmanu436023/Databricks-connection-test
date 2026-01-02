select 

TRIM(r.company_id)||'-'||company.company_dscr as "Express Partner"
, r.flt_num as "Flight num"
,r.dprt_sta_cd as "Dep Stn"
,r.arrv_sta_cd as "Arrv Stn"
,r.CNXL_REASON_CD||' - '||cnxl.cnxl_reason_dscr as "Cancel Description"
,r.charged_equip_id as Nose
,r.EST_CNXL_PAX_cnt as PBT

,s.sch_dprt_dtml as "Sch Dep time (Local)"
,r.CNXL_DTML as "Time cancel (Local)"

,CASE 
	WHEN extract(year from r.CNXL_DTML) <> 0001 
	then
		case 
			when r.CNXL_DTML < s.sch_dprt_dtml 
			THEN '('||cast(left(trim(ltrim(dateadd(seconds,-datediff(second,s.sch_dprt_dtml,r.CNXL_DTML),'1900-01-01 00:00:00'),'1900-01-01') ),5) as VARCHAR(20)) || ')'
			ELSE cast(left(trim(ltrim(dateadd(seconds,datediff(second,s.sch_dprt_dtml,r.CNXL_DTML), '1900-01-01 00:00:00'),'1900-01-01') ),5) AS VARCHAR(20)) 
		end 
	else
	cast(trim(ltrim(dateadd(seconds,datediff(second,r.CNXL_DTML, r.CNXL_DTML),'1900-01-01 00:00:00' ),'1900-01-01')) AS VARCHAR(20)) 
END

as "HH:MM Cnxl (Before)/After Sch dep time"

,ex.ex_company_id as "Ex Sec"


 from co_prod_vmdb.VW_FLT_LEG_OPERATION_CNXL r

LEFT JOIN
co_prod_vmdb.RTF_FLT_LEG_OPERATION S

ON R.company_id = s.company_id
and r.report_dt = s.report_dt
and r.flt_num = s.flt_num
and r.dprt_sta_cd = s.dprt_sta_cd
and r.arrv_sta_cd = s.arrv_sta_cd


left join 
 co_prod_vmdb.cnxl_reason_cd cnxl
on r.CNXL_REASON_CD = cnxl.cnxl_reason_cd

LEFT JOIN
co_prod_vmdb.VW_RTF_FLT_LEG_UAX_EX ex

ON R.company_id = ex.company_id
and r.report_dt = ex.report_dt
and r.flt_num = ex.flt_num
and r.dprt_sta_cd = ex.dprt_sta_cd
and r.arrv_sta_cd = ex.arrv_sta_cd

left join 
co_prod_vmdb.company company
on r.company_id = company.company_id


where r.company_id not in ('bu','ei') 
and r.company_id not in ('ua','co')
and r.report_dt = current_date
and r.cnxl_cd = 'C'
and r.DIVERT_REASON_CD = ''


order by 1,2,3,8

