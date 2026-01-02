SELECT COMPANY_ID
	,r.report_year AS REPORT_YEAR
	,r.report_month AS REPORT_MONTH
	,CASE 
		WHEN r.company_id IN (
				'ua'
				,'co'
				)
			THEN 'Mainline'
		ELSE 'Express'
		END AS ML_EX_ind
	,SUM(CASE 
			WHEN r.sch_cd = 's'
				THEN 1
			ELSE 0
			END) AS Scheduled_Flights
FROM co_prod_vmdb.rtf_flt_leg_operation_ss r
WHERE r.sch_cd IN (
		's'
		,'u'
		)
	AND r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND r.return_type_cd = ' '
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
	AND r.report_dt BETWEEN CURRENT_DATE - 7
		AND CURRENT_DATE - 1
GROUP BY 1
	,2
	,3
	,4