SELECT 'Yest' AS TimePeriod
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND r.dprt_diff_minutes < 15
				THEN 1
			ELSE 0
			END) AS Short_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes >= 15
				THEN 1
			ELSE 0
			END) AS Long_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				THEN 1
			ELSE 0
			END) AS Total_Dprt_Dlys
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
				AND trim(DELAY.delay_cd) IN ('FX')
				THEN 1
			ELSE 0
			END) AS FX_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FR'
					,'FY'
					)
				THEN 1
			ELSE 0
			END) AS FR_FY_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FD'
					,'FN'
					,'FQ'
					,'FS'
					)
				THEN 1
			ELSE 0
			END) AS FD_N_Q_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IX'
					,'IR'
					,'IS'
					)
				THEN 1
			ELSE 0
			END) AS IX_R_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IL'
					,'IM'
					)
				THEN 1
			ELSE 0
			END) AS IL_IM_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IB'
					,'ID'
					,'IE'
					,'IG'
					,'IP'
					,'IZ'
					)
				THEN 1
			ELSE 0
			END) AS IB_D_E_G_P_Z_Dlys
	,sum(CASE 
			WHEN sch_cd = 's'
				THEN 1
			ELSE 0
			END) AS sked
	,(Short_Dlys * 100.00) / sked AS Short_Dly_Rate
	,(Long_Dlys * 100.00) / sked AS Long_Dly_Rate
	,(Total_Dprt_Dlys * 100.00) / sked AS Total_Dprt_Dly_Rate
	,(FO_Dlys * 100.00) / sked AS FO_Dly_Rate
	,(IF_Dlys * 100.00) / sked AS IF_Dly_Rate
FROM CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
LEFT JOIN CO_PROD_VMDB.RTF_DELAY_TYPE DELAY ON trim(r.sta_delay_cd) = trim(DELAY.delay_cd)
	AND r.report_dt >= DELAY.eff_dt
	AND r.report_dt < DELAY.disc_dt
WHERE r.report_dt = CURRENT_DATE - 2
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

UNION

SELECT 'MTD' AS TimePeriod
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND r.dprt_diff_minutes < 15
				THEN 1
			ELSE 0
			END) AS Short_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes >= 15
				THEN 1
			ELSE 0
			END) AS Long_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				THEN 1
			ELSE 0
			END) AS Total_Dprt_Dlys
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
				AND trim(DELAY.delay_cd) IN ('FX')
				THEN 1
			ELSE 0
			END) AS FX_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FR'
					,'FY'
					)
				THEN 1
			ELSE 0
			END) AS FR_FY_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FD'
					,'FN'
					,'FQ'
					,'FS'
					)
				THEN 1
			ELSE 0
			END) AS FD_N_Q_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IX'
					,'IR'
					,'IS'
					)
				THEN 1
			ELSE 0
			END) AS IX_R_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IL'
					,'IM'
					)
				THEN 1
			ELSE 0
			END) AS IL_IM_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IB'
					,'ID'
					,'IE'
					,'IG'
					,'IP'
					,'IZ'
					)
				THEN 1
			ELSE 0
			END) AS IB_D_E_G_P_Z_Dlys
	,sum(CASE 
			WHEN sch_cd = 's'
				THEN 1
			ELSE 0
			END) AS sked
	,(Short_Dlys * 100.00) / sked AS Short_Dly_Rate
	,(Long_Dlys * 100.00) / sked AS Long_Dly_Rate
	,(Total_Dprt_Dlys * 100.00) / sked AS Total_Dprt_Dly_Rate
	,(FO_Dlys * 100.00) / sked AS FO_Dly_Rate
	,(IF_Dlys * 100.00) / sked AS IF_Dly_Rate
FROM CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
LEFT JOIN CO_PROD_VMDB.RTF_DELAY_TYPE DELAY ON trim(r.sta_delay_cd) = trim(DELAY.delay_cd)
	AND r.report_dt >= DELAY.eff_dt
	AND r.report_dt < DELAY.disc_dt
WHERE r.report_dt BETWEEN CURRENT_DATE - 1 - EXTRACT(DAY FROM CURRENT_DATE - 1) + 1
		AND CURRENT_DATE - 2
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

UNION

SELECT '2019' AS TimePeriod
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND r.dprt_diff_minutes < 15
				THEN 1
			ELSE 0
			END) AS Short_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes >= 15
				THEN 1
			ELSE 0
			END) AS Long_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				THEN 1
			ELSE 0
			END) AS Total_Dprt_Dlys
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
				AND trim(DELAY.delay_cd) IN ('FX')
				THEN 1
			ELSE 0
			END) AS FX_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FR'
					,'FY'
					)
				THEN 1
			ELSE 0
			END) AS FR_FY_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FD'
					,'FN'
					,'FQ'
					,'FS'
					)
				THEN 1
			ELSE 0
			END) AS FD_N_Q_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IX'
					,'IR'
					,'IS'
					)
				THEN 1
			ELSE 0
			END) AS IX_R_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IL'
					,'IM'
					)
				THEN 1
			ELSE 0
			END) AS IL_IM_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IB'
					,'ID'
					,'IE'
					,'IG'
					,'IP'
					,'IZ'
					)
				THEN 1
			ELSE 0
			END) AS IB_D_E_G_P_Z_Dlys
	,sum(CASE 
			WHEN sch_cd = 's'
				THEN 1
			ELSE 0
			END) AS sked
	,(Short_Dlys * 100.00) / sked AS Short_Dly_Rate
	,(Long_Dlys * 100.00) / sked AS Long_Dly_Rate
	,(Total_Dprt_Dlys * 100.00) / sked AS Total_Dprt_Dly_Rate
	,(FO_Dlys * 100.00) / sked AS FO_Dly_Rate
	,(IF_Dlys * 100.00) / sked AS IF_Dly_Rate
FROM CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
LEFT JOIN CO_PROD_VMDB.RTF_DELAY_TYPE DELAY ON trim(r.sta_delay_cd) = trim(DELAY.delay_cd)
	AND r.report_dt >= DELAY.eff_dt
	AND r.report_dt < DELAY.disc_dt
WHERE r.report_year = '2019'
	AND report_month = extract(month FROM CURRENT_DATE - 1)
	AND report_day BETWEEN 1
		AND extract(day FROM CURRENT_DATE - 2)
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

UNION

SELECT 'L7D' AS TimePeriod
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND r.dprt_diff_minutes < 15
				THEN 1
			ELSE 0
			END) AS Short_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes >= 15
				THEN 1
			ELSE 0
			END) AS Long_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				THEN 1
			ELSE 0
			END) AS Total_Dprt_Dlys
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
				AND trim(DELAY.delay_cd) IN ('FX')
				THEN 1
			ELSE 0
			END) AS FX_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FR'
					,'FY'
					)
				THEN 1
			ELSE 0
			END) AS FR_FY_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'FD'
					,'FN'
					,'FQ'
					,'FS'
					)
				THEN 1
			ELSE 0
			END) AS FD_N_Q_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IX'
					,'IR'
					,'IS'
					)
				THEN 1
			ELSE 0
			END) AS IX_R_S_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IL'
					,'IM'
					)
				THEN 1
			ELSE 0
			END) AS IL_IM_Dlys
	,SUM(CASE 
			WHEN trim(r.cnxl_cd) = ''
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.dprt_diff_minutes > 0
				AND trim(DELAY.delay_cd) IN (
					'IB'
					,'ID'
					,'IE'
					,'IG'
					,'IP'
					,'IZ'
					)
				THEN 1
			ELSE 0
			END) AS IB_D_E_G_P_Z_Dlys
	,sum(CASE 
			WHEN sch_cd = 's'
				THEN 1
			ELSE 0
			END) AS sked
	,(Short_Dlys * 100.00) / sked AS Short_Dly_Rate
	,(Long_Dlys * 100.00) / sked AS Long_Dly_Rate
	,(Total_Dprt_Dlys * 100.00) / sked AS Total_Dprt_Dly_Rate
	,(FO_Dlys * 100.00) / sked AS FO_Dly_Rate
	,(IF_Dlys * 100.00) / sked AS IF_Dly_Rate
FROM CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
LEFT JOIN CO_PROD_VMDB.RTF_DELAY_TYPE DELAY ON trim(r.sta_delay_cd) = trim(DELAY.delay_cd)
	AND r.report_dt >= DELAY.eff_dt
	AND r.report_dt < DELAY.disc_dt
WHERE r.report_dt BETWEEN CURRENT_DATE - 8
		AND CURRENT_DATE - 2
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
ORDER BY 1 DESC