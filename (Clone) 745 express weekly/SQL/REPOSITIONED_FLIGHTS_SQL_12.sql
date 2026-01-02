SELECT r.company_id || '-' || company.company_dscr AS "Express Partner"
	,r.flt_num AS "Flight num"
	,r.sch_dprt_sta_cd AS "Dep Stn"
	,r.sch_arrv_sta_cd AS "Arrv Stn"
	,r.report_dt AS "Date"
	,r.equip_id AS Nose
	,sch_dprt_dtml AS "Sch Dep time (Local)"
	,sch_arrv_dtml AS "Sch Arrv time (Local)"
	,r.act_DPRT_DTMZ AS "Act Dep time (Local)"
	,r.act_ARRV_DTMZ AS "Act Arrv time (Local)"
FROM co_prod_vmdb.rtf_flt_leg_operation_ss r
LEFT JOIN co_prod_vmdb.company company ON r.company_id = company.company_id
WHERE report_dt BETWEEN CURRENT_DATE - 7
		AND CURRENT_DATE - 1
	AND sch_dprt_sta_cd = dprt_sta_cd
	AND r.company_id NOT IN (
		'bu'
		,'ei'
		,'UA'
		,'CO'
		)
	AND r.RETURN_TYPE_CD = ' '
	AND sch_cd = 'F'
ORDER BY 1
	,2