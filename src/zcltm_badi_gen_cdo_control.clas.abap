class ZCLTM_BADI_GEN_CDO_CONTROL definition
  public
  final
  create public .

public section.

  interfaces /SCMTMS/IF_GEN_CDO_CONTROL .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_BADI_GEN_CDO_CONTROL IMPLEMENTATION.


  METHOD /scmtms/if_gen_cdo_control~check_cdo_is_active.

    IF sy-uname EQ 'S-PIUSER'.
      CLEAR: ct_active_root_key, cv_active.
    ENDIF.

    IF 1 = 2.

      "Create reduced transactional change object logging only ROOT updates
      "- It would also be possible to log e.g. Rates Validities by adding change notifications for Rate Validity
      "  In this case the transactional change object should be used to extract the Rate Validity changes of the
      "  current session, and then to take them over into this local change object being used to determine all CDO
      "  relevant changes for CDO.
      "- BO changes of the currently saved session can be determined as follows:
      DATA: lo_txm      TYPE REF TO /bobf/if_tra_transaction_mgr,
            lo_tx_chg   TYPE REF TO /bobf/if_tra_change,
            lo_chg      TYPE REF TO /bobf/if_frw_change,
            lo_chg_root TYPE REF TO /bobf/if_frw_change,
            lt_chg      TYPE /bobf/t_frw_change,
            lo_cdo      TYPE REF TO /bofu/cl_change_doc_handling,
            lo_conf     TYPE REF TO /bobf/if_frw_configuration.

      TRY.
          lo_conf = /bobf/cl_frw_factory=>get_configuration( iv_bo_key = iv_bo_key ).
          lo_cdo  = /bofu/cl_change_doc_handling=>get_instance( iv_bo_key = iv_bo_key ).
        CATCH /bobf/cx_frw.  "Unknown BO -> leave without doing anything
          EXIT.
      ENDTRY.

      lo_txm    = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
      lo_tx_chg = lo_txm->get_transactional_changes( ).
      lo_tx_chg->get_bo_changes(
        EXPORTING
          iv_bo_key = iv_bo_key
        IMPORTING
          eo_change = lo_chg
      ).
      lo_chg->get_changes(
        IMPORTING
          et_change       =  lt_chg
      ).

      lo_chg_root = /bobf/cl_frw_factory=>get_change( ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
