SELECT 'UA' AS Carrier
	,r.report_year AS REPORT_YEAR
	,extract(month FROM CURRENT_DATE - 1) AS REPORT_MONTH
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
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS Scheduled_Flights
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
				AND r.cnxl_reason_cd <> 'nt'
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
			END) AS dep0_cnt
	,SUM(CASE 
			WHEN r.ex_company_id <> ' '
				AND ex_dprt_diff_minutes <= 0
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
			WHEN r.dprt_sta_cd = r.sch_dprt_sta_cd
				AND r.sch_cd IN (
					's'
					,'u'
					)
				AND r.cnxl_cd = ' '
				AND r.dprt_diff_minutes <= 0
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS new_dep0_cnt
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
			END) AS arr0_cnt
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
			END) AS arr0_cnt
	,SUM(CASE 
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS STAR_SCH_FLT_COUNT
	,SUM(CASE 
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.SCH_CD IN (
					'S'
					,'U'
					)
				AND r.DPRT_STA_CD = r.SCH_DPRT_STA_CD
				AND r.CNXL_CD = ' '
				AND r.DPRT_DIFF_MINUTES < 1
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.cs_flg = 1
				AND r.cs_qualified_ox_delay_ind = 'q'
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.ch_flg = 1
				AND r.ch_qualified_ok_delay_ind = 'q'
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.qualified_bus_delay_ind = 'q'
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS STAR_D00_COUNT
	,Sum(CASE 
			WHEN ex_company_id = ' '
				AND r.CNXL_CD = 'C'
				AND r.DIVERT_REASON_CD = '  '
				AND left(r.CNXL_REASON_CD, 1) <> 'X'
				AND r.cnxl_reason_cd <> 'nt'
				AND r.cnxl_reason_cd NOT LIKE 'z%'
				AND r.report_month = extract(month FROM CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS Controllable_Cancels
	,SUM(CASE 
			WHEN r.sch_cd = 's'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS Scheduled_Flights_Yest
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
				AND r.cnxl_reason_cd <> 'nt'
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
			END) AS cnxl_flt_yest
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
			END) AS dep0_cnt_yest
	,SUM(CASE 
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
				AND r.dprt_diff_minutes <= 0
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS new_dep0_cnt_yest
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
			END) AS arr0_cnt_yest
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
			END) AS arr0_cnt_yest
	,SUM(CASE 
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS STAR_SCH_FLT_COUNT_YEST
	,SUM(CASE 
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.SCH_CD IN (
					'S'
					,'U'
					)
				AND r.DPRT_STA_CD = r.SCH_DPRT_STA_CD
				AND r.CNXL_CD = ' '
				AND r.DPRT_DIFF_MINUTES < 1
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.cs_flg = 1
				AND r.cs_qualified_ox_delay_ind = 'q'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.ch_flg = 1
				AND r.ch_qualified_ok_delay_ind = 'q'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			WHEN r.EQUIP_CONNECT_CD = 'H'
				AND r.qualified_bus_delay_ind = 'q'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS STAR_D00_COUNT_YEST
	,Sum(CASE 
			WHEN ex_company_id = ' '
				AND r.CNXL_CD = 'C'
				AND r.DIVERT_REASON_CD = '  '
				AND left(r.CNXL_REASON_CD, 1) <> 'X'
				AND r.cnxl_reason_cd <> 'nt'
				AND r.cnxl_reason_cd NOT LIKE 'z%'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS Controllable_Cancels_yest
	,SUM(CASE 
			WHEN r.sch_cd = 's'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS Scheduled_Flights_DateMinus2
	,SUM(CASE 
			WHEN r.ex_company_id <> ' '
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			WHEN r.dprt_sta_cd = r.sch_dprt_sta_cd
				AND r.cnxl_cd = ' '
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS Completed_Flights_DateMinus2
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
			END) AS dep0_cnt_DateMinus2
	,SUM(CASE 
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
				AND r.dprt_diff_minutes <= 0
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS new_dep0_cnt_DateMinus2
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
			END) AS arr0_cnt_DateMinus2
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
			END) AS arr0_cnt_DateMinus2
	,sum(CASE 
			WHEN r.sch_cd IN (
					's'
					,'u'
					)
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.act_dprt_dtmz <> '0001-01-01 00:00:00'
				AND r.report_dt BETWEEN (CURRENT_DATE - 1 - extract(day FROM CURRENT_DATE - 1) + 1)
					AND (CURRENT_DATE - 1)
				THEN 1
			WHEN r.sch_cd IN ('s')
				AND r.cnxl_reason_cd NOT IN (
					' '
					,'zd'
					,'zo'
					,'zf'
					)
				AND r.divert_reason_cd = ' '
				AND r.report_dt BETWEEN (CURRENT_DATE - 1 - extract(day FROM CURRENT_DATE - 1) + 1)
					AND (CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS dep_cnt
	,sum(CASE 
			WHEN r.sch_cd IN (
					's'
					,'u'
					)
				AND r.sch_arrv_sta_cd = r.arrv_sta_cd
				AND r.off_dtmz <> '0001-01-01 00:00:00'
				AND r.report_dt BETWEEN (CURRENT_DATE - 1 - extract(day FROM CURRENT_DATE - 1) + 1)
					AND (CURRENT_DATE - 1)
				THEN 1
			WHEN r.sch_cd IN ('s')
				AND r.cnxl_reason_cd NOT IN (
					' '
					,'zd'
					,'zo'
					,'zf'
					)
				AND r.divert_reason_cd = ' '
				AND r.report_dt BETWEEN (CURRENT_DATE - 1 - extract(day FROM CURRENT_DATE - 1) + 1)
					AND (CURRENT_DATE - 1)
				THEN 1
			ELSE 0
			END) AS arr_cnt
	,sum(CASE 
			WHEN r.sch_cd IN (
					's'
					,'u'
					)
				AND r.sch_dprt_sta_cd = r.dprt_sta_cd
				AND r.act_dprt_dtmz <> '0001-01-01 00:00:00'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			WHEN r.sch_cd IN ('s')
				AND r.cnxl_reason_cd NOT IN (
					' '
					,'zd'
					,'zo'
					,'zf'
					)
				AND r.divert_reason_cd = ' '
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS dep_cnt_yest
	,sum(CASE 
			WHEN r.sch_cd IN (
					's'
					,'u'
					)
				AND r.sch_arrv_sta_cd = r.arrv_sta_cd
				AND r.off_dtmz <> '0001-01-01 00:00:00'
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			WHEN r.sch_cd IN ('s')
				AND r.cnxl_reason_cd NOT IN (
					' '
					,'zd'
					,'zo'
					,'zf'
					)
				AND r.divert_reason_cd = ' '
				AND r.report_dt = CURRENT_DATE - 2
				THEN 1
			ELSE 0
			END) AS arr_cnt_yest
FROM co_prod_vmdb.rtf_flt_leg_operation_ss r
LEFT JOIN co_prod_vmdb.rtf_flt_leg_conx_saver adj ON adj.report_dt = r.report_dt
	AND adj.dprt_sta_cd = r.dprt_sta_cd
	AND adj.company_id = r.company_id
	AND adj.flt_num = r.flt_num
	AND adj.cnxl_cd = r.cnxl_cd
	AND adj.act_dprt_dtmz = r.act_dprt_dtmz
LEFT JOIN co_prod_vmdb.vw_rtf_flt_leg_cust_hold c ON r.company_id = c.company_id
	AND r.report_dt = c.report_dt
	AND r.flt_num = c.flt_num
	AND r.dprt_sta_cd = c.dprt_sta_cd
	AND r.cnxl_cd = c.cnxl_cd
	AND r.act_dprt_dtmz = c.act_dprt_dtmz
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
	AND r.report_dt BETWEEN (CURRENT_DATE - 1 - extract(day FROM CURRENT_DATE - 1))
		AND (CURRENT_DATE - 2)
GROUP BY 1
	,2
	,3
	,4