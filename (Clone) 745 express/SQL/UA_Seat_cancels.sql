SELECT sum(Seat_cnxl_mtd) * 1.000 / nullif(sum(sch_cap_mtd), 0) AS Seat_CNXL_Rate_mtd
	,sum(Seat_cnxl_yest)* 1.000 / nullif(sum(sch_cap_yest), 0) AS Seat_CNXL_Rate_yest
	,sum(Seat_cnxl_L7) * 1.000 / nullif(sum(sch_cap_L7), 0) AS Seat_CNXL_Rate_L7
FROM (
	SELECT SUM(CASE 
				WHEN r.sch_cd='s' and r.report_month = extract(month FROM CURRENT_DATE - 1)
					THEN sch_cap
				ELSE 0
				END) AS sch_cap_mtd
		,SUM(CASE 
				when r.ex_company_id <> ' ' and r.company_id not in ('bu', 'ei', 'af', 'vs')  and r.report_month = extract(month FROM CURRENT_DATE - 1) then 0
				when r.report_month = extract(month FROM CURRENT_DATE - 1) and r.sch_cd='s' and r.cnxl_cd='c' and r.cnxl_reason_cd not in ('nt')  
				  and r.cnxl_reason_cd not like 'z%' and r.divert_reason_cd = ' '
				  and r.company_id not in ('bu', 'ei', 'af', 'vs') 
				  then SCH_CAP else 0 end ) AS Seat_cnxl_mtd
		,SUM(CASE 
				WHEN r.sch_cd='s' and r.report_dt = CURRENT_DATE - 1
					THEN sch_cap
				ELSE 0
				END) AS sch_cap_yest
		,SUM(CASE 
				when r.ex_company_id <> ' ' and r.company_id not in ('bu', 'ei', 'af', 'vs')  and r.report_dt = CURRENT_DATE - 1 then 0
				when r.report_dt = CURRENT_DATE - 1 and r.sch_cd='s' and r.cnxl_cd='c' and r.cnxl_reason_cd not in ('nt')  
				  and r.cnxl_reason_cd not like 'z%' and r.divert_reason_cd = ' '
				  and r.company_id not in ('bu', 'ei', 'af', 'vs') 
				  then SCH_CAP else 0 end ) AS Seat_cnxl_yest
		,SUM(CASE 
				WHEN r.sch_cd='s' and r.report_dt BETWEEN CURRENT_DATE - 8
						AND CURRENT_DATE - 1
					THEN sch_cap
				ELSE 0
				END) AS sch_cap_L7
		,SUM(CASE 
				when r.ex_company_id <> ' ' and r.company_id not in ('bu', 'ei', 'af', 'vs')  and r.report_dt BETWEEN CURRENT_DATE - 8 AND CURRENT_DATE - 1 then 0
				when r.report_dt BETWEEN CURRENT_DATE - 8 AND CURRENT_DATE - 1 and r.sch_cd='s' and r.cnxl_cd='c' and r.cnxl_reason_cd not in ('nt') 
				  and r.cnxl_reason_cd not like 'z%' and r.divert_reason_cd = ' '
				  and r.company_id not in ('bu', 'ei', 'af', 'vs') 
				  then SCH_CAP else 0 end ) AS Seat_cnxl_L7
	FROM CO_PROD_VMDB.RTF_FLT_LEG_OPERATION_SS R
	LEFT JOIN CO_PROD_VMDB.RTF_CNXL_TYPE C ON R.CNXL_REASON_CD = C.CNXL_REASON_CD
	WHERE R.COMPANY_ID NOT IN (
			'UA'
			,'CO'
			)
		AND R.COMPANY_ID NOT IN (
			'BU'
			,'EI'
			)
		AND R.SCH_CD IN (
			'S'
			,'U'
			)
		AND r.report_dt BETWEEN (CURRENT_DATE - 1 - extract(day FROM CURRENT_DATE - 1))
			AND last_day(CURRENT_DATE - 1)
		AND TRIM(R.RETURN_TYPE_CD) = ''
	) T