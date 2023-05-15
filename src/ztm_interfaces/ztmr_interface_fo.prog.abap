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

START-OF-SELECTION.

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

  DATA(lo_tor) = NEW zcltm_interface_fo( ).
  lo_tor->execute( ).
