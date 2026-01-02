SELECT TRIM(r.company_id) || '-' || company.company_dscr AS "Express Partner"
	,r.flt_num AS "Flight num"
	,r.dprt_sta_cd AS "Dep Stn"
	,r.arrv_sta_cd AS "Arrv Stn"
	,r.CNXL_REASON_CD || ' - ' || cnxl.cnxl_reason_dscr AS "Cancel Description"
	,r.charged_equip_id AS Nose
	,r.EST_CNXL_PAX_cnt AS PBT
	,s.sch_dprt_dtml AS "Sch Dep time (Local)"
	,r.CNXL_DTML AS "Time cancel (Local)"
	,CASE 
		WHEN extract(year FROM r.CNXL_DTML) <> 0001
			THEN CASE 
					WHEN r.CNXL_DTML < s.sch_dprt_dtml
						THEN '('||cast(left(trim(ltrim(dateadd(seconds,-datediff(second,s.sch_dprt_dtml,r.CNXL_DTML),'1900-01-01 00:00:00'),'1900-01-01') ),5) as VARCHAR(20)) || ')'
					ELSE cast(left(trim(ltrim(dateadd(seconds,datediff(second,s.sch_dprt_dtml,r.CNXL_DTML), '1900-01-01 00:00:00'),'1900-01-01') ),5) AS VARCHAR(20)) 
					END
		ELSE cast(trim(ltrim(dateadd(seconds,datediff(second,r.CNXL_DTML, r.CNXL_DTML),'1900-01-01 00:00:00' ),'1900-01-01')) AS VARCHAR(20)) 
		END AS "HH:MM Cnxl (Before)/After Sch dep time"
	,ex.ex_company_id AS "Ex Sec"
FROM co_prod_vmdb.VW_FLT_LEG_OPERATION_CNXL r
LEFT JOIN co_prod_vmdb.RTF_FLT_LEG_OPERATION S ON R.company_id = s.company_id
	AND r.report_dt = s.report_dt
	AND r.flt_num = s.flt_num
	AND r.dprt_sta_cd = s.dprt_sta_cd
	AND r.arrv_sta_cd = s.arrv_sta_cd
LEFT JOIN co_prod_vmdb.cnxl_reason_cd cnxl ON r.CNXL_REASON_CD = cnxl.cnxl_reason_cd
LEFT JOIN co_prod_vmdb.VW_RTF_FLT_LEG_UAX_EX ex ON R.company_id = ex.company_id
	AND r.report_dt = ex.report_dt
	AND r.flt_num = ex.flt_num
	AND r.dprt_sta_cd = ex.dprt_sta_cd
	AND r.arrv_sta_cd = ex.arrv_sta_cd
LEFT JOIN co_prod_vmdb.company company ON r.company_id = company.company_id
WHERE r.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND r.company_id NOT IN (
		'ua'
		,'co'
		)
	AND r.report_dt = CURRENT_DATE
	AND r.cnxl_cd = 'C'
	AND r.DIVERT_REASON_CD = ''
ORDER BY 1
	,2
	,3
	,8