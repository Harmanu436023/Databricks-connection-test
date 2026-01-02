SELECT TRIM(r.company_id) AS COMPANY_ID
	,r.report_dt AS "Date"
	,r.cnxl_cd
	,cnxl.CNXL_TYPE_DSCR AS "Cancel division"
	,TRIM(ex.ex_company_id) AS ex_company_id
	,count(*)
FROM co_prod_vmdb.VW_FLT_LEG_OPERATION_CNXL r
LEFT JOIN co_prod_vmdb.cnxl_reason_cd cnxl ON r.CNXL_REASON_CD = cnxl.cnxl_reason_cd
LEFT JOIN co_prod_vmdb.VW_RTF_FLT_LEG_UAX_EX ex ON R.company_id = ex.company_id
	AND r.report_dt = ex.report_dt
	AND r.flt_num = ex.flt_num
	AND r.dprt_sta_cd = ex.dprt_sta_cd
	AND r.arrv_sta_cd = ex.arrv_sta_cd
WHERE r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
	AND r.report_dt = CURRENT_DATE
	AND r.cnxl_cd = 'C'
	AND trim(r.DIVERT_REASON_CD) = ''
GROUP BY 1
	,2
	,3
	,4
	,5