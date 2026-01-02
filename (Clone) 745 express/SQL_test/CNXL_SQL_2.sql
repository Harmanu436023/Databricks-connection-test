Select  company_id
	,r.report_dt AS "Date"
	,r.cnxl_cd
	,cnxl.CNXL_TYPE_DSCR AS "Cancel division"
	,ex_company_id
	,count(*)
 From co_prod_vmdb.rtf_flt_leg_operation_ss r
 LEFT JOIN co_prod_vmdb.cnxl_reason_cd cnxl ON r.CNXL_REASON_CD = cnxl.cnxl_reason_cd
 Where r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND trim(r.return_type_cd) = ''
	AND r.sch_cd IN (
		's'
		,'u'
		)
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
	AND r.report_dt = CURRENT_DATE - 2
	AND r.cnxl_cd = 'C'
	AND r.DIVERT_REASON_CD = ''
 Group by 1
	,2
	,3
	,4
	,5