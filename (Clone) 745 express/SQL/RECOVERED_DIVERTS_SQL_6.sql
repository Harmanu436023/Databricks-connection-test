SELECT 'YEST' AS Time_period
	,sum(CASE 
			WHEN divert_status = 'TERM'
				THEN 1
			ELSE 0
			END) AS divert_unrecovered
	,sum(CASE 
			WHEN divert_status = 'CONT'
				THEN 1
			ELSE 0
			END) AS divert_recovered
FROM co_prod_vmdb.rtf_flt_leg_operation_Ss r
WHERE r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
	AND trim(r.return_type_cd) = ''
	AND r.report_dt = CURRENT_DATE - 1

UNION ALL

SELECT 'MTD' AS Time_period
	,sum(CASE 
			WHEN divert_status = 'TERM'
				THEN 1
			ELSE 0
			END) AS divert_unrecovered
	,sum(CASE 
			WHEN divert_status = 'CONT'
				THEN 1
			ELSE 0
			END) AS divert_recovered
FROM co_prod_vmdb.rtf_flt_leg_operation_Ss r
WHERE r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
	AND r.return_type_cd = ''
	AND r.report_month = extract(month FROM CURRENT_DATE - 1)
	AND extract(year FROM r.report_dt) = extract(year FROM CURRENT_DATE - 1)