SELECT d.company_id || '-' || company.company_dscr AS "Express Partner"
	,d.flt_num AS "Flight num"
	,d.segment AS "Original segment"
	,d.dprt_sta_cd AS "Dep Stn"
	,d.dvrt_sta_cd AS "Divert Stn"
	,d.act_arrv_sta_cd AS "Act Arrv Stn"
	,d.divert_reason_cd || ' - ' || dc.divert_reason_dscr AS "Divert Description"
	,d.AC_type AS "A/C type"
	,d.equip_id AS Nose
	,d.sch_arrv_dtml AS "Sch Arrv time (Local)"
	,d.divert_tml AS "Divert time (Divert sta local)"
	,d.act_arrv_tml_ AS "Act Arrv time (Local)"
	,d.arrv_diff_minutes_ AS "Arrv diff mins"
	,d.STATUS
	,CASE 
		WHEN trim(d.act_arrv_sta_cd) IS NULL
			AND d.STATUS LIKE '%TERM%'
			THEN 'No'
		ELSE 'Yes'
		END AS "Divert recovered"
FROM co_prod_vmdb.vw_rtf_divert d
LEFT JOIN co_prod_vmdb.company company ON d.company_id = company.company_id
LEFT JOIN co_prod_vmdb.cnxl_reason_cd cnxl ON d.CNXL_REASON_CD = cnxl.cnxl_reason_cd
LEFT JOIN co_prod_vmdb.divert_reason dc ON d.divert_reason_cd = dc.divert_reason_cd
WHERE d.company_id NOT IN (
		'bu'
		,'ei'
		)
	AND d.report_dt = CURRENT_DATE - 1
	AND d.company_id NOT IN (
		'ua'
		,'co'
		)
