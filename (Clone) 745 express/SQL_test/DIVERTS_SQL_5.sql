SELECT 'YEST' AS Time_period
	,count(*) AS Total_diverts
FROM co_prod_vmdb.vw_rtf_divert d
WHERE d.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND d.report_dt = CURRENT_DATE - 2
	AND company_id NOT IN (
		'ua'
		,'co'
		)

UNION ALL

SELECT 'MTD' AS Time_period
	,count(*) AS Total_diverts
FROM co_prod_vmdb.vw_rtf_divert d
WHERE d.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND extract(month FROM d.report_dt) = extract(month FROM CURRENT_DATE - 2)
	AND extract(year FROM d.report_dt) = extract(year FROM CURRENT_DATE - 2)
	AND company_id NOT IN (
		'ua'
		,'co'
		)

AND d.report_dt <= CURRENT_DATE - 2