Select r.company_id||'-'||company.company_dscr as "Express Partner"
, r.flt_num as "Flight num"
,r.sch_dprt_sta_cd as "Dep Stn"
,r.sch_arrv_sta_cd as "Arrv Stn"
,r.report_dt as "Date"
,r.equip_id as Nose
,sch_dprt_dtml as "Sch Dep time (Local)"
,sch_arrv_dtml as "Sch Arrv time (Local)"
,r.act_DPRT_DTMZ as "Act Dep time (Local)"
,r.act_ARRV_DTMZ as "Act Arrv time (Local)"
 From co_prod_vmdb.rtf_flt_leg_operation_ss r
 LEFT JOIN 
co_prod_vmdb.company company
on r.company_id = company.company_id
 Where 
	report_dt= current_date - 1
	and sch_dprt_sta_cd = dprt_sta_cd
	and r.company_id not in ('bu','ei','UA','CO')
	and r.RETURN_TYPE_CD = ' '
	and sch_cd='F'
	
	order by 1,2