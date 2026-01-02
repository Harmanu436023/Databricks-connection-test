select 
'UA' as Carrier,
r.report_year as REPORT_YEAR,
extract(month  From  current_date - 1) as REPORT_MONTH,
case when r.company_id in ('ua','co') then 'Mainline'
          else 'Express' end as ML_EX_ind,
SUM(CASE when r.sch_cd = 's'  THEN 1 ELSE 0 END) AS Scheduled_Flights,
sum(case when r.ex_company_id <> ' ' and r.company_id not in ('bu', 'ei', 'af', 'vs')  then 0
                  when  r.sch_cd='s' and r.cnxl_cd='c' and r.cnxl_reason_cd != 'nt'  and r.cnxl_reason_cd not like 'z%' and r.divert_reason_cd = ' ' and r.company_id not in ('bu', 'ei', 'af', 'vs') then 1 else 0 end ) as cnxl_flt_mtd
,SUM(CASE when r.ex_company_id <> ' ' and r.ex_dprt_diff_minutes <= 0  then 1
                     when r.sch_dprt_sta_cd=r.dprt_sta_cd and r.cnxl_cd=' ' and r.dprt_diff_minutes <= 0 then 1 else 0 end) AS dep0_cnt
                     				 
					 
					  
 , SUM(case when r.ex_company_id <> ' ' and ex_dprt_diff_minutes <= 0  then 1
                                 when r.cs_flg= 1 and r.cs_qualified_ox_delay_ind = 'q'then 1
                                 when r.ch_flg=1 and  r.ch_qualified_ok_delay_ind = 'q' then 1
								 when r.qualified_bus_delay_ind = 'q' then 1 
                                 when r.dprt_sta_cd = r.sch_dprt_sta_cd and r.sch_cd in ('s', 'u') and r.cnxl_cd= ' ' and r.dprt_diff_minutes <= 0  then 1 else 0 end) as new_dep0_cnt					  
                     
,SUM(CASE when r.ex_company_id <> ' ' and r.ex_arrv_diff_minutes <= 0  then 1 
                     when r.cnxl_cd = ' ' AND r.sch_arrv_sta_cd = r.arrv_sta_cd AND r.arrv_diff_minutes <= 0  THEN 1 ELSE 0 END) AS arr0_cnt
                     
,SUM(CASE when r.ex_company_id <> ' ' and r.ex_arrv_diff_minutes <= 14 then 1 
                     when r.cnxl_cd = ' ' AND r.sch_arrv_sta_cd = r.arrv_sta_cd AND r.arrv_diff_minutes <= 14 THEN 1 ELSE 0 END) AS arr14_cnt
					 
,SUM(CASE WHEN r.EQUIP_CONNECT_CD = 'H' and  r.report_month = extract(month  From  current_date - 1) THEN 1 ELSE 0 END) AS STAR_SCH_FLT_COUNT
,SUM(CASE WHEN r.EQUIP_CONNECT_CD = 'H' AND r.SCH_CD IN ('S','U') AND r.DPRT_STA_CD = r.SCH_DPRT_STA_CD AND r.CNXL_CD = ' ' AND r.DPRT_DIFF_MINUTES < 1  and  r.report_month = extract(month  From  current_date - 1) THEN 1 
						WHEN  r.EQUIP_CONNECT_CD = 'H' AND r.cs_flg= 1 and r.cs_qualified_ox_delay_ind = 'q' and  r.report_month = extract(month  From  current_date - 1) THEN 1
					  	WHEN  r.EQUIP_CONNECT_CD = 'H' AND r.ch_flg=1 AND r.ch_qualified_ok_delay_ind = 'q' and  r.report_month = extract(month  From  current_date - 1) THEN 1 
						WHEN r.EQUIP_CONNECT_CD = 'H' and r.qualified_bus_delay_ind = 'q' and  r.report_month = extract(month  From  current_date - 1) THEN 1 ELSE 0 END) AS STAR_D00_COUNT 
,Sum(case when ex_company_id = ' ' and r.CNXL_CD='C' and r.DIVERT_REASON_CD='  ' and left(r.CNXL_REASON_CD,1)<>'X' and  r.cnxl_reason_cd != 'nt' and r.cnxl_reason_cd not like 'z%' and  r.report_month = extract(month  From  current_date - 1)
     then 1 else 0 end) as Controllable_Cancels
 From co_prod_vmdb.rtf_flt_leg_operation_ss r 
 LEFT JOIN co_prod_vmdb.rtf_flt_leg_conx_saver adj
on adj.report_dt = r.report_dt and adj.dprt_sta_cd = r.dprt_sta_cd and adj.company_id = r.company_id and adj.flt_num = r.flt_num and adj.cnxl_cd = r.cnxl_cd and adj.act_dprt_dtmz = r.act_dprt_dtmz
 LEFT JOIN
          co_prod_vmdb.vw_rtf_flt_leg_cust_hold c
on r.company_id = c.company_id and r.report_dt=c.report_dt and r.flt_num=c.flt_num and r.dprt_sta_cd = c.dprt_sta_cd and r.cnxl_cd=c.cnxl_cd and
      r.act_dprt_dtmz = c.act_dprt_dtmz
 Where r.sch_cd in ('s','u')
and r.company_id not in ('bu','ei')
and r.return_type_cd= ' '
and r.company_id not in ('ua','co')
and r.report_dt between  current_date - 8 and  current_date - 2
 Group by 1,2,3,4