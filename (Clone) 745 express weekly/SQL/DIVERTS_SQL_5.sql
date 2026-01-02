SELECT 'YEST' AS Time_period
	,count(*) AS Total_diverts
FROM co_prod_vmdb.vw_rtf_divert d
WHERE d.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND d.report_dt BETWEEN CURRENT_DATE - 7
		AND CURRENT_DATE - 1
	AND company_id NOT IN (
		'ua'
		,'co'
		)