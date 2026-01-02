SELECT count(*) AS count_flights
FROM co_prod_vmdb.rtf_flt_leg_operation
WHERE report_dt = CURRENT_DATE - 2
	AND act_dprt_dtmz = '0001-01-01 00:00:00'
	AND EST_DPRT_DTMZ > sch_dprt_dtmz
	AND sch_dprt_sta_cd = dprt_sta_cd
	AND company_id NOT IN (
		'bu'
		,'ei'
		,'UA'
		,'CO'
		)