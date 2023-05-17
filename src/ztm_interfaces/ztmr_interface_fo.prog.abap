*&---------------------------------------------------------------------*
*& Report ZTMR_INTERFACE_FO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztmr_interface_fo.

DATA: gv_eventid                 TYPE tbtcm-eventid,
      gv_eventparm               TYPE tbtcm-eventparm,
      gv_external_program_active TYPE tbtcm-xpgactive,
      gv_jobcount                TYPE tbtcm-jobcount,
      gv_jobname                 TYPE tbtcm-jobname,
      gv_stepcount               TYPE tbtcm-stepcount.

CONSTANTS: gc_gko       TYPE string VALUE 'GKO',
           gc_greenmile TYPE string VALUE 'GEENMILE',
           gc_trafegus  TYPE string VALUE 'TRAFEGUS'.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_gko  TYPE abap_bool AS CHECKBOX DEFAULT '',
              p_gren TYPE abap_bool AS CHECKBOX DEFAULT '',
              p_traf TYPE abap_bool AS CHECKBOX DEFAULT ''.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  IF sy-batch = abap_true.
    "Obtêm os dados do Job
    CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
      IMPORTING
        eventid                 = gv_eventid
        eventparm               = gv_eventparm
        external_program_active = gv_external_program_active
        jobcount                = gv_jobcount
        jobname                 = gv_jobname
        stepcount               = gv_stepcount
      EXCEPTIONS
        no_runtime_info         = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      RETURN.
    ENDIF.

    "Recupera o nome do programa sendo executado no job
    SELECT SINGLE
           tbtco~jobname,
           tbtco~jobcount,
           tbtcp~stepcount,
           tbtcp~progname
      FROM tbtco
      INNER JOIN tbtcp
        ON  tbtcp~jobname  = tbtco~jobname
        AND tbtcp~jobcount = tbtco~jobcount
      INTO @DATA(ls_job)
      WHERE tbtco~jobname   = @gv_jobname
        AND tbtco~jobcount  = @gv_jobcount
        AND tbtcp~stepcount = @gv_stepcount.

    IF sy-subrc NE 0.
      CLEAR ls_job.
    ENDIF.

    "Verifica se possui outro Job em execução
    SELECT COUNT(*)
      FROM tbtco
      INNER JOIN tbtcp
        ON  tbtcp~jobname  = tbtco~jobname
        AND tbtcp~jobcount = tbtco~jobcount
      WHERE tbtco~jobcount <> gv_jobcount
        AND tbtco~status   = 'R'
        AND tbtcp~progname = ls_job-progname.

    IF sy-subrc IS INITIAL.

      MESSAGE s081(ztm_gko) DISPLAY LIKE 'E'.
      RETURN.

    ENDIF.

  ENDIF.

  IF sy-batch = abap_false AND p_gko = abap_false AND p_gren = abap_false AND p_traf = abap_false.
    MESSAGE e154(ztm_gko).
    RETURN.
  ENDIF.

  DATA(lo_tor) = NEW zcltm_interface_fo( ).
  IF p_gko = abap_true.
    lo_tor->execute( gc_gko ).
  ENDIF.
  IF p_gren = abap_true.
    lo_tor->execute( gc_greenmile ).
  ENDIF.
  IF p_traf = abap_true.
    lo_tor->execute( gc_trafegus ).
  ENDIF.
  IF p_gko = abap_false AND p_gren = abap_false AND p_traf = abap_false.
    lo_tor->execute( ).
  ENDIF.
