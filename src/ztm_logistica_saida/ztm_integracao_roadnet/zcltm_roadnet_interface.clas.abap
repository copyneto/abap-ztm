CLASS zcltm_roadnet_interface DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_input_filter_consult_sessio,
        region_identity TYPE werks_d,
        date_start      TYPE sydatum,
        date_end        TYPE sydatum,
        routes          TYPE zctgtm_route_id,
      END OF ty_input_filter_consult_sessio.

    METHODS:
      consult_sessions
        IMPORTING
          is_input_filter_consult_sessio TYPE ty_input_filter_consult_sessio
        RETURNING
          VALUE(rt_return)               TYPE zcltm_dt_consulta_sessao__tab1.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      determine_filter_consult
        IMPORTING
          is_input_filter_consult_sessio TYPE ty_input_filter_consult_sessio
        RETURNING
          VALUE(rs_return)               TYPE zcltm_mt_consulta_sessao,

      interf_consult_session_roadnet
        IMPORTING
          is_complete_filter_consult TYPE zcltm_mt_consulta_sessao
        RETURNING
          VALUE(rs_return)           TYPE zcltm_mt_consulta_sessao_resp.


    CONSTANTS:
      gc_false_string   TYPE string VALUE 'false',
      gc_true_string    TYPE string VALUE 'true',
      gc_rdlstop_string TYPE string VALUE 'rdlStop'.

ENDCLASS.



CLASS zcltm_roadnet_interface IMPLEMENTATION.

  METHOD consult_sessions.
    DATA(ls_complete_filter_consult) = determine_filter_consult( is_input_filter_consult_sessio ).
    DATA(ls_interf_sessions_roadnet) = interf_consult_session_roadnet( ls_complete_filter_consult ).
    rt_return = CORRESPONDING #( ls_interf_sessions_roadnet-mt_consulta_sessao_resp-sessions ).
  ENDMETHOD.

  METHOD determine_filter_consult.
    rs_return = VALUE #(
      mt_consulta_sessao-criteria-region_identity = is_input_filter_consult_sessio-region_identity
      mt_consulta_sessao-criteria-date_start      = is_input_filter_consult_sessio-date_start
      mt_consulta_sessao-criteria-date_end        = COND #(
        WHEN is_input_filter_consult_sessio-date_end IS NOT INITIAL
        THEN is_input_filter_consult_sessio-date_end
        ELSE is_input_filter_consult_sessio-date_start
      )
      mt_consulta_sessao-options-retrieve_built      = gc_false_string
      mt_consulta_sessao-options-retrieve_active     = gc_false_string
      mt_consulta_sessao-options-retrieve_equipment  = gc_false_string
      mt_consulta_sessao-options-retrieve_published  = gc_true_string
      mt_consulta_sessao-options-level               = gc_rdlstop_string
    ).
  ENDMETHOD.

  METHOD interf_consult_session_roadnet.
    TRY.
        NEW zcltm_co_si_consulta_sessao_ou( )->si_consulta_sessao_out(
          EXPORTING
            output = is_complete_filter_consult
          IMPORTING
            input  = rs_return
        ).
      CATCH cx_ai_system_fault.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
