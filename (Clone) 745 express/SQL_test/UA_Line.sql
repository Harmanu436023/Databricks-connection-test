SELECT COALESCE(o1.TIME_STAMP, NULL) AS TIME_STAMP
	,COALESCE(o1.CITY, i1.CITY) AS CITY
	,COALESCE(o1.STATION, i1.STATION) AS STATION
	,COALESCE(o1.CARRIER, i1.CARRIER) AS CARRIER
	,COALESCE(o1.ml_ex_ind, i1.ml_ex_ind) AS ML_EX_IND
	,COALESCE(o1.sched_flt_now, 0) AS sched_flt_now
	,COALESCE(o1.cnxl_flt_now, 0) AS cnxl_flt_now
	,COALESCE(i1.a0_flt_now, NULL) AS a0_flt_now
	,COALESCE(i1.a14_flt_now, NULL) AS a14_flt_now
	,COALESCE(o1.d0_flt_now_o, NULL) AS d0_flt_now_o
	,COALESCE(o1.d0_flt_now, NULL) AS d0_flt_now
	,COALESCE(o1.sched_flt_mtd, NULL) AS sched_flt_mtd
	,COALESCE(o1.cnxl_flt_mtd, NULL) AS cnxl_flt_mtd
	,COALESCE(i1.a0_flt_mtd, NULL) AS a0_flt_mtd
	,COALESCE(i1.a14_flt_mtd, NULL) AS a14_flt_mtd
	,COALESCE(o1.d0_flt_mtd_o, NULL) AS d0_flt_mtd_o
	,COALESCE(o1.d0_flt_mtd, NULL) AS d0_flt_mtd
	,COALESCE(o1.sched_flt_ytd, NULL) AS sched_flt_ytd
	,COALESCE(o1.comp_flt_ytd, NULL) AS comp_flt_ytd
	,COALESCE(i1.a0_flt_ytd, NULL) AS a0_flt_ytd
	,COALESCE(i1.a14_flt_ytd, NULL) AS a14_flt_ytd
	,COALESCE(o1.d0_flt_ytd_o, NULL) AS d0_flt_ytd_o
	,COALESCE(o1.d0_flt_ytd, NULL) AS d0_flt_ytd
	,COALESCE(i1.in_sched_flt_now, NULL) AS in_sched_flt_now
	,COALESCE(i1.in_sched_flt_mtd, NULL) AS in_sched_flt_mtd
	,COALESCE(i1.in_sched_flt_ytd, NULL) AS in_sched_flt_ytd
FROM (
	SELECT CURRENT_TIMESTAMP(6) AS TIME_STAMP
		,CAST(CASE 
				WHEN r.sch_dprt_sta_cd NOT IN (
						'den'
						,'ewr'
						,'iad'
						,'iah'
						,'lax'
						,'ord'
						,'sfo'
						)
					AND d.country_cd IN ('us')
					THEN 'Line Dom'
				WHEN r.sch_dprt_sta_cd NOT IN (
						'den'
						,'ewr'
						,'iad'
						,'iah'
						,'lax'
						,'ord'
						,'sfo'
						)
					AND d.country_cd NOT IN ('us')
					THEN 'Line Int'
				ELSE 'OTHER'
				END AS VARCHAR(255)) AS CITY
		,TRIM(r.sch_dprt_sta_cd) AS STATION
		,'UA' AS CARRIER
		,CAST(CASE 
				WHEN r.company_id IN (
						'co'
						,'ua'
						)
					THEN 'Mainline'
				ELSE 'Express'
				END AS VARCHAR(255)) AS ML_EX_IND
		,SUM(CASE 
				WHEN r.sch_cd = 's'
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				ELSE 0
				END) AS sched_flt_now
		,sum(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.company_id NOT IN (
						'bu'
						,'ei'
						,'af'
						,'vs'
						)
					AND r.report_dt = CURRENT_DATE - 2
					THEN 0
				WHEN r.report_dt = CURRENT_DATE - 2
					AND r.sch_cd = 's'
					AND r.cnxl_cd = 'c'
					AND r.cnxl_reason_cd != 'nt'
					AND r.cnxl_reason_cd NOT LIKE 'z%'
					AND r.divert_reason_cd = ' '
					AND r.company_id NOT IN (
						'bu'
						,'ei'
						,'af'
						,'vs'
						)
					THEN 1
				ELSE 0
				END) AS cnxl_flt_now
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_dprt_diff_minutes <= 0
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.sch_dprt_sta_cd = r.dprt_sta_cd
					AND r.cnxl_cd = ' '
					AND r.dprt_diff_minutes <= 0
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				ELSE 0
				END) AS d0_flt_now_o
		,sum(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_dprt_diff_minutes <= 0
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.cs_flg = 1
					AND r.cs_qualified_ox_delay_ind = 'q'
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.ch_flg = 1
					AND r.ch_qualified_ok_delay_ind = 'q'
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.qualified_bus_delay_ind = 'q'
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.sch_cd IN (
						's'
						,'u'
						)
					AND r.sch_dprt_sta_cd = r.dprt_sta_cd
					AND r.cnxl_cd = ' '
					AND r.return_type_cd = ' '
					AND r.dprt_diff_minutes <= 0
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				ELSE 0
				END) AS d0_flt_now
		,SUM(CASE 
				WHEN r.sch_cd = 's'
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				ELSE 0
				END) AS sched_flt_mtd
		,sum(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.company_id NOT IN (
						'bu'
						,'ei'
						,'af'
						,'vs'
						)
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 0
				WHEN r.report_month = extract(month FROM CURRENT_DATE - 1)
					AND r.sch_cd = 's'
					AND r.cnxl_cd = 'c'
					AND r.cnxl_reason_cd != 'nt'
					AND r.cnxl_reason_cd NOT LIKE 'z%'
					AND r.divert_reason_cd = ' '
					AND r.company_id NOT IN (
						'bu'
						,'ei'
						,'af'
						,'vs'
						)
					THEN 1
				ELSE 0
				END) AS cnxl_flt_mtd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_dprt_diff_minutes <= 0
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.sch_dprt_sta_cd = r.dprt_sta_cd
					AND r.cnxl_cd = ' '
					AND r.dprt_diff_minutes <= 0
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				ELSE 0
				END) AS d0_flt_mtd_o
		,sum(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_dprt_diff_minutes <= 0
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.cs_flg = 1
					AND r.cs_qualified_ox_delay_ind = 'q'
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.ch_flg = 1
					AND r.ch_qualified_ok_delay_ind = 'q'
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.qualified_bus_delay_ind = 'q'
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.sch_cd IN (
						's'
						,'u'
						)
					AND r.sch_dprt_sta_cd = r.dprt_sta_cd
					AND r.cnxl_cd = ' '
					AND r.return_type_cd = ' '
					AND r.dprt_diff_minutes <= 0
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				ELSE 0
				END) AS d0_flt_mtd
		,SUM(CASE 
				WHEN r.sch_cd = 's'
					THEN 1
				ELSE 0
				END) AS sched_flt_ytd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					THEN 1
				WHEN r.dprt_sta_cd = r.sch_dprt_sta_cd
					AND (
						r.cnxl_cd = ' '
						OR (
							r.cnxl_cd = 'c'
							AND r.cnxl_reason_cd = 'nt'
							)
						)
					THEN 1
				ELSE 0
				END) AS comp_flt_ytd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_dprt_diff_minutes <= 0
					THEN 1
				WHEN r.sch_dprt_sta_cd = r.dprt_sta_cd
					AND r.cnxl_cd = ' '
					AND r.dprt_diff_minutes <= 0
					THEN 1
				ELSE 0
				END) AS d0_flt_ytd_o
		,sum(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_dprt_diff_minutes <= 0
					THEN 1
				WHEN r.cs_flg = 1
					AND r.cs_qualified_ox_delay_ind = 'q'
					THEN 1
				WHEN r.ch_flg = 1
					AND r.ch_qualified_ok_delay_ind = 'q'
					THEN 1
				WHEN r.qualified_bus_delay_ind = 'q'
					THEN 1
				WHEN r.sch_cd IN (
						's'
						,'u'
						)
					AND r.sch_dprt_sta_cd = r.dprt_sta_cd
					AND r.cnxl_cd = ' '
					AND r.return_type_cd = ' '
					AND r.dprt_diff_minutes <= 0
					THEN 1
				ELSE 0
				END) AS d0_flt_ytd
	FROM co_prod_vmdb.rtf_flt_leg_operation_ss r
	INNER JOIN co_prod_vmdb.location d ON r.sch_dprt_sta_cd = d.location_cd
	WHERE r.report_year = extract(year FROM CURRENT_DATE - 1)
		AND r.report_dt <= CURRENT_DATE - 2
		AND r.company_id <> 'bu'
		AND r.sch_cd IN (
			's'
			,'u'
			)
		AND r.return_type_cd = ' '
		AND r.company_id NOT IN (
			'co'
			,'ua'
			)
	GROUP BY 1
		,2
		,3
		,4
		,5
	) o1
FULL OUTER JOIN (
	SELECT CURRENT_TIMESTAMP(6) AS TIME_STAMP
		,CAST(CASE 
				WHEN r.sch_arrv_sta_cd NOT IN (
						'den'
						,'ewr'
						,'iad'
						,'iah'
						,'lax'
						,'ord'
						,'sfo'
						)
					AND a.country_cd IN ('us')
					THEN 'Line Dom'
				WHEN r.sch_arrv_sta_cd NOT IN (
						'den'
						,'ewr'
						,'iad'
						,'iah'
						,'lax'
						,'ord'
						,'sfo'
						)
					AND a.country_cd NOT IN ('us')
					THEN 'Line Int'
				ELSE 'OTHER'
				END AS VARCHAR(255)) AS CITY
		,TRIM(r.sch_arrv_sta_cd) AS STATION
		,'UA' AS CARRIER
		,CAST(CASE 
				WHEN r.company_id IN (
						'co'
						,'ua'
						)
					THEN 'Mainline'
				ELSE 'Express'
				END AS VARCHAR(255)) AS ML_EX_IND
		,SUM(CASE 
				WHEN r.sch_cd = 's'
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				ELSE 0
				END) AS in_sched_flt_now
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_arrv_diff_minutes <= 0
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.cnxl_cd = ' '
					AND r.sch_arrv_sta_cd = r.arrv_sta_cd
					AND r.arrv_diff_minutes <= 0
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				ELSE 0
				END) AS a0_flt_now
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_arrv_diff_minutes <= 14
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				WHEN r.cnxl_cd = ' '
					AND r.sch_arrv_sta_cd = r.arrv_sta_cd
					AND r.arrv_diff_minutes <= 14
					AND r.report_dt = CURRENT_DATE - 2
					THEN 1
				ELSE 0
				END) AS a14_flt_now
		,SUM(CASE 
				WHEN r.sch_cd = 's'
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				ELSE 0
				END) AS in_sched_flt_mtd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_arrv_diff_minutes <= 0
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.cnxl_cd = ' '
					AND r.sch_arrv_sta_cd = r.arrv_sta_cd
					AND r.arrv_diff_minutes <= 0
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				ELSE 0
				END) AS a0_flt_mtd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_arrv_diff_minutes <= 14
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				WHEN r.cnxl_cd = ' '
					AND r.sch_arrv_sta_cd = r.arrv_sta_cd
					AND r.arrv_diff_minutes <= 14
					AND r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN 1
				ELSE 0
				END) AS a14_flt_mtd
		,SUM(CASE 
				WHEN r.sch_cd = 's'
					THEN 1
				ELSE 0
				END) AS in_sched_flt_ytd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_arrv_diff_minutes <= 0
					THEN 1
				WHEN r.cnxl_cd = ' '
					AND r.sch_arrv_sta_cd = r.arrv_sta_cd
					AND r.arrv_diff_minutes <= 0
					THEN 1
				ELSE 0
				END) AS a0_flt_ytd
		,SUM(CASE 
				WHEN r.ex_company_id <> ' '
					AND r.ex_arrv_diff_minutes <= 14
					THEN 1
				WHEN r.cnxl_cd = ' '
					AND r.sch_arrv_sta_cd = r.arrv_sta_cd
					AND r.arrv_diff_minutes <= 14
					THEN 1
				ELSE 0
				END) AS a14_flt_ytd
	FROM co_prod_vmdb.rtf_flt_leg_operation_ss r
	INNER JOIN co_prod_vmdb.location a ON r.sch_arrv_sta_cd = a.location_cd
	WHERE r.report_year = extract(year FROM CURRENT_DATE - 1)
		AND r.report_dt <= CURRENT_DATE - 2
		AND r.company_id <> 'bu'
		AND r.sch_cd IN (
			's'
			,'u'
			)
		AND r.return_type_cd = ' '
		AND r.company_id NOT IN (
			'co'
			,'ua'
			)
	GROUP BY 1
		,2
		,3
		,4
		,5
	) i1 ON o1.CITY = i1.CITY
	AND o1.CARRIER = i1.CARRIER
	AND o1.STATION = i1.STATION
	AND o1.ML_EX_IND = i1.ML_EX_IND
WHERE o1.CITY <> 'OTHER'
	AND i1.CITY <> 'Other'