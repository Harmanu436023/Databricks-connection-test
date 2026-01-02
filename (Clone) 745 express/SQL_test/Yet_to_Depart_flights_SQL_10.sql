SELECT r.company_id || '-' || company.company_dscr AS "Express Partner"
	,r.flt_num AS "Flight num"
	,r.sch_dprt_sta_cd AS "Dep Stn"
	,r.sch_arrv_sta_cd AS "Arrv Stn"
	,r.report_dt AS "Date"
	,r.equip_id AS Nose
	,sch_dprt_dtml AS "Sch Dep time (Local)"
	,r.EST_DPRT_DTMZ AS "Est Dep time (Local)"
	,sch_arrv_dtml AS "Sch Arrv time (Local)"
	,r.EST_ARRV_DTMZ AS "Est Arrv time (Local)"
FROM co_prod_vmdb.rtf_flt_leg_operation r
LEFT JOIN co_prod_vmdb.company company ON r.company_id = company.company_id
LEFT JOIN CO_PROD_VMDB.RTF_DELAY_TYPE DELAY ON r.sta_delay_cd = DELAY.delay_cd
WHERE report_dt = CURRENT_DATE - 2
	AND act_dprt_dtmz = '0001-01-01 00:00:00'
	AND EST_DPRT_DTMZ > sch_dprt_dtmz
	AND sch_dprt_sta_cd = dprt_sta_cd
	AND r.company_id NOT IN (
		'bu'
		,'ei'
		,'UA'
		,'CO'
		)
ORDER BY 1
	,2