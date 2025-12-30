Select company_id,
sch_cd,
cnxl_cd,
flt_num,
report_dt,
sch_dprt_sta_cd,
sch_arrv_sta_cd,
dprt_sta_cd,
arrv_sta_cd,
sch_dprt_dtml,
act_dprt_dtml,
sch_arrv_dtml,
act_arrv_dtml,
dprt_diff_minutes,
arrv_diff_minutes,
sta_delay_cd,
sta_delay_minutes,
pred_delay_reason_cd,
pred_delay_keywords,
oper_delay_cd,
oper_delay_minutes
 From co_prod_vmdb.rtf_flt_leg_operation_ss snap
 Where trim(sch_cd) in ('s','u')
and report_dt = ':DATE:'
and trim(company_id) = 'C5' 
and trim(return_type_cd) =''
ORDER BY REPORT_DT,sch_dprt_sta_cd,flt_num,sch_cd, act_dprt_dtml