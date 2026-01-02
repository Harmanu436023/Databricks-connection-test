SELECT company_id
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'WEATHER/ATC'
				THEN 1
			ELSE 0
			END) AS WA_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'TECHNICAL OPERATIONS-AIRCRAFT'
				THEN 1
			ELSE 0
			END) AS TO_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'FLIGHT OPERATIONS'
				THEN 1
			ELSE 0
			END) AS FO_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'IN-FLIGHT SERVICES'
				THEN 1
			ELSE 0
			END) AS IF_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'AIRPORT OPERATIONS'
				THEN 1
			ELSE 0
			END) AS AO_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'NETWORK OPERARIONS CENTER'
				THEN 1
			ELSE 0
			END) AS NOC_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'TECHNOLOGY'
				THEN 1
			ELSE 0
			END) AS IT_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr = 'CATERING OPERATIONS'
				THEN 1
			ELSE 0
			END) AS Catering_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				THEN 1
			ELSE 0
			END) AS dly_flts
	,sum(CASE 
			WHEN sch_cd = 's'
				THEN 1
			ELSE 0
			END) AS sked
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND delay_type_dscr IN ('CORE4')
				THEN 1
			ELSE 0
			END) AS Core4_dly
FROM CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
LEFT JOIN CO_PROD_VMDB.RTF_DELAY_TYPE DELAY ON trim(r.sta_delay_cd) = trim(DELAY.delay_cd)
	AND r.report_dt >= DELAY.eff_dt
	AND r.report_dt < DELAY.disc_dt
WHERE r.report_dt BETWEEN CURRENT_DATE - 7
		AND CURRENT_DATE - 1
	AND R.SCH_CD IN (
		'S'
		,'u'
		)
	AND TRIM(R.RETURN_TYPE_CD) = ''
	AND r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
GROUP BY 1
ORDER BY 1