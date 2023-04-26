***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: JOB de Cálculo de custo                                *
*** AUTOR : WILLIAN HAZOR – META                                      *
*** FUNCIONAL: Jefferson Alcantara – META                             *
*** DATA : 03.05.2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA  | AUTOR | DESCRIÇÃO                                         *
***-------------------------------------------------------------------*
***       |       |                                                   *
**********************************************************************
REPORT ztmr_calculo_custo MESSAGE-ID ztm_gestao_frete.

CONSTANTS: gc_modulo_tm     TYPE ze_param_modulo VALUE 'TM',
           gc_chave1_job     TYPE ze_param_chave VALUE 'JOB_CALCULO_CUSTO',
           gc_chave1_fat     TYPE ze_param_chave VALUE 'FAT_SELECION_PROF',
           gc_jobname_step1 TYPE btcjob VALUE 'CAL_CUSTO',
           gc_jobname_step2 TYPE btcjob VALUE 'DOC_FAT_CUSTO',
           gc_jobname_step3 TYPE btcjob VALUE 'LAN_DOC_CUSTO'.

DATA: gv_profile_step2 TYPE ze_param_chave,
      gt_range_doc     TYPE RANGE OF /scmtms/tor_fo_id.

SELECT modulo, chave1, low, high
  FROM ztca_param_val
  INTO TABLE @DATA(lt_param_val)
  WHERE modulo = @gc_modulo_tm
    AND chave1 = @gc_chave1_job.

IF sy-subrc <> 0.
  MESSAGE e108(ztm_gestao_frete).
ENDIF.

SELECT SINGLE chave2
  FROM ztca_param_val
  INTO gv_profile_step2
  WHERE modulo = gc_modulo_tm
    AND chave1 = gc_chave1_fat.

IF sy-subrc <> 0.
  MESSAGE e106(ztm_gestao_frete). " Parâmetro FAT_SELECION_PROF não configurado
ENDIF.

LOOP AT lt_param_val ASSIGNING FIELD-SYMBOL(<fs_param_val>).

  PERFORM f_executa_step1 USING <fs_param_val>-low  <fs_param_val>-high.
  PERFORM f_executa_step2 USING <fs_param_val>-low  <fs_param_val>-high.
  PERFORM f_executa_step3 USING <fs_param_val>-low  <fs_param_val>-high.

ENDLOOP.

MESSAGE s109(ztm_gestao_frete). " Parâmetro FAT_SELECION_PROF não configurado

FORM f_executa_step1 USING us_profile us_expedidor.


  DATA: lv_jobname  LIKE tbtco-jobname,
        lv_jobcount LIKE tbtco-jobcount.

  lv_jobname = gc_jobname_step1.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.
    MESSAGE e107(ztm_gestao_frete).
  ENDIF.

  SUBMIT /scmtms/sfir_create_batch
          VIA JOB lv_jobname NUMBER lv_jobcount
          WITH pv_slprf = us_profile
          WITH incl_dc  = abap_true
          WITH so_shipp = us_expedidor
          WITH so_invdt = sy-datum
          WITH pv_tnsfr = abap_true
          WITH pv_test  = abap_false
          WITH pv_msg   = abap_true
          WITH pv_tc_m  = abap_true
          WITH pv_inv   = /scmtms/if_sfir_c=>sc_inv_creation_method-individual
          AND RETURN.

  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = lv_jobcount
      jobname              = lv_jobname
      strtimmed            = abap_true
    EXCEPTIONS
      cant_start_immediate = 1                  " Cannot Start Immediately
      invalid_startdate    = 2                  " Start Condition is Invalid
      jobname_missing      = 3                  " Job Name Missing (Wildcards Allowed)
      job_close_failed     = 4                  " Error During JOB_CLOSE, See SYSLOG
      job_nosteps          = 5                  " Job Specified Does Not Contain Any Steps
      job_notex            = 6                  " Specified Job Does Not Exist
      lock_failed          = 7                  " Lock Attempt Failed
      invalid_target       = 8                  " Target Server or Group is Invalid
      invalid_time_zone    = 9                  " Time Zone Invalid
      OTHERS               = 10.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DO.
    SELECT SINGLE jobname, jobcount, status
      FROM tbtco
      INTO @DATA(ls_tbtco)
      WHERE jobname = @lv_jobname
        AND jobcount = @lv_jobcount.

    IF sy-subrc <> 0.
      MESSAGE e107(ztm_gestao_frete).
    ENDIF.

    IF ls_tbtco-status = 'A'.
      MESSAGE e107(ztm_gestao_frete).
    ENDIF.

    IF ls_tbtco-status = 'F'.
      EXIT.
    ENDIF.
    WAIT UP TO 2 SECONDS.
  ENDDO.
ENDFORM.
FORM f_executa_step2 USING us_profile us_expedidor.

  DATA: lv_jobname  LIKE tbtco-jobname,
        lv_jobcount LIKE tbtco-jobcount.

  lv_jobname = gc_jobname_step2.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.
    MESSAGE e107(ztm_gestao_frete).
  ENDIF.

  SUBMIT /scmtms/sfir_create_batch
          VIA JOB lv_jobname NUMBER lv_jobcount
          WITH pv_slprf = us_profile
          WITH incl_dc  = abap_true
          WITH so_shipp = us_expedidor
          WITH so_invdt = sy-datum
          WITH pv_tnsfr = abap_true
          WITH pv_test  = abap_false
          WITH pv_msg   = abap_true
          WITH pv_tc_m  = abap_true
          WITH pv_inv   = /scmtms/if_sfir_c=>sc_inv_creation_method-individual
          AND RETURN.

  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = lv_jobcount
      jobname              = lv_jobname
      strtimmed            = abap_true
    EXCEPTIONS
      cant_start_immediate = 1                  " Cannot Start Immediately
      invalid_startdate    = 2                  " Start Condition is Invalid
      jobname_missing      = 3                  " Job Name Missing (Wildcards Allowed)
      job_close_failed     = 4                  " Error During JOB_CLOSE, See SYSLOG
      job_nosteps          = 5                  " Job Specified Does Not Contain Any Steps
      job_notex            = 6                  " Specified Job Does Not Exist
      lock_failed          = 7                  " Lock Attempt Failed
      invalid_target       = 8                  " Target Server or Group is Invalid
      invalid_time_zone    = 9                  " Time Zone Invalid
      OTHERS               = 10.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DO.
    SELECT SINGLE jobname, jobcount, status
      FROM tbtco
      INTO @DATA(ls_tbtco)
      WHERE jobname = @lv_jobname
        AND jobcount = @lv_jobcount.

    IF sy-subrc <> 0.
      MESSAGE e107(ztm_gestao_frete).
    ENDIF.

    IF ls_tbtco-status = 'A'.
      MESSAGE e107(ztm_gestao_frete).
    ENDIF.

    IF ls_tbtco-status = 'F'.
      EXIT.
    ENDIF.
    WAIT UP TO 2 SECONDS.
  ENDDO.
ENDFORM.

FORM f_executa_step3 USING us_profile us_expedidor.

  DATA: lv_jobname  LIKE tbtco-jobname,
        lv_jobcount LIKE tbtco-jobcount.

  SELECT sfir_id
    FROM ZVTM_D_SF_ROT
    where LIFECYCLE EQ  '02'  OR
          LIFECYCLE EQ  '18'
    INTO TABLE @DATA(lt_sfir_id).

  CHECK lt_sfir_id IS NOT INITIAL.

  lv_jobname = gc_jobname_step3.

  CLEAR gt_range_doc[].

  LOOP AT lt_sfir_id ASSIGNING FIELD-SYMBOL(<fs_sfir_id>).

    APPEND VALUE #( sign = 'I' option = 'EQ' low = <fs_sfir_id>-sfir_id ) TO gt_range_doc.

    CHECK lines( gt_range_doc[] ) = 5000.

    PERFORM f_submit_step3 USING us_profile us_expedidor.

    CLEAR gt_range_doc[].

  ENDLOOP.

  IF gt_range_doc IS NOT INITIAL.
    PERFORM f_submit_step3 USING us_profile us_expedidor.
  ENDIF.

ENDFORM.
FORM f_submit_step3 USING us_profile us_expedidor.
  DATA: lv_jobname  LIKE tbtco-jobname,
        lv_jobcount LIKE tbtco-jobcount.

  lv_jobname = gc_jobname_step3.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = lv_jobname
    IMPORTING
      jobcount         = lv_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc <> 0.
    MESSAGE e107(ztm_gestao_frete).
  ENDIF.

  SUBMIT /scmtms/sfir_create_batch
          VIA JOB lv_jobname NUMBER lv_jobcount
          WITH pv_slprf = us_profile
          WITH incl_dc  = abap_true
          WITH so_torid = gt_range_doc[]
          WITH so_shipp = us_expedidor
          WITH so_invdt = sy-datum
          WITH pv_tnsfr = abap_true
          WITH pv_test  = abap_false
          WITH pv_msg   = abap_true
          WITH pv_tc_m  = abap_true
          WITH pv_inv   = /scmtms/if_sfir_c=>sc_inv_creation_method-individual
          AND RETURN.

  CALL FUNCTION 'JOB_CLOSE'
    EXPORTING
      jobcount             = lv_jobcount
      jobname              = lv_jobname
      strtimmed            = abap_true
    EXCEPTIONS
      cant_start_immediate = 1                  " Cannot Start Immediately
      invalid_startdate    = 2                  " Start Condition is Invalid
      jobname_missing      = 3                  " Job Name Missing (Wildcards Allowed)
      job_close_failed     = 4                  " Error During JOB_CLOSE, See SYSLOG
      job_nosteps          = 5                  " Job Specified Does Not Contain Any Steps
      job_notex            = 6                  " Specified Job Does Not Exist
      lock_failed          = 7                  " Lock Attempt Failed
      invalid_target       = 8                  " Target Server or Group is Invalid
      invalid_time_zone    = 9                  " Time Zone Invalid
      OTHERS               = 10.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DO.
    SELECT SINGLE jobname, jobcount, status
      FROM tbtco
      INTO @DATA(ls_tbtco)
      WHERE jobname = @lv_jobname
        AND jobcount = @lv_jobcount.

    IF sy-subrc <> 0.
      MESSAGE e107(ztm_gestao_frete).
    ENDIF.

    IF ls_tbtco-status = 'A'.
      MESSAGE e107(ztm_gestao_frete).
    ENDIF.

    IF ls_tbtco-status = 'F'.
      EXIT.
    ENDIF.
    WAIT UP TO 2 SECONDS.
  ENDDO.
ENDFORM.
