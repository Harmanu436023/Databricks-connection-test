SELECT count(*)
FROM co_prod_vmdb.rtf_flt_leg_operation_ss r
LEFT JOIN co_prod_vmdb.company company ON r.company_id = company.company_id
WHERE report_dt = CURRENT_DATE - 1
	AND sch_dprt_sta_cd = dprt_sta_cd
	AND r.company_id NOT IN (
		'bu'
		,'ei'
		,'UA'
		,'CO'
		)
	AND r.RETURN_TYPE_CD = ' '
	AND sch_cd = 'F'