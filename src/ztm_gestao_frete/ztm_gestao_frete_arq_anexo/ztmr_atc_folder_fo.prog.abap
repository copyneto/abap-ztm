*&---------------------------------------------------------------------*
*& Report ZTMR_ATC_FOLDER_FO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztmr_atc_folder_fo.

INCLUDE ztmr_atc_folder_fo_top.

START-OF-SELECTION.

  SELECT id,
         parametro
    FROM zttm_pcockpit001
    INTO TABLE @DATA(lt_param_dir)
    WHERE id EQ '2'.

  IF sy-subrc IS NOT INITIAL.
    EXIT.
  ENDIF.

  LOOP AT lt_param_dir ASSIGNING FIELD-SYMBOL(<fs_param_dir>).

    DATA(lo_file) = NEW zcltm_atc_folder_fo( ).

    lo_file->get_directory_listing( EXPORTING iv_directory         = <fs_param_dir>-parametro  " Directory name
                                    IMPORTING et_directory_content = DATA(lt_dir) ).           " Conteúdo de diretório

    DELETE lt_dir WHERE name EQ '.' OR
                        name EQ '..'.

    IF lt_dir[] IS INITIAL.
      CONTINUE.
    ENDIF.

    lo_file->process_dir( it_directory_content = lt_dir ).

    DATA(lt_return) = lo_file->get_msgs( ).
    gt_msgs = CORRESPONDING #( BASE ( gt_msgs ) lt_return ).

  ENDLOOP.

  IF gt_msgs IS NOT INITIAL.

    DATA(go_log) = NEW zclca_save_log( iv_object = 'ZTM' ).
    go_log->create_log( iv_subobject = 'ZGKO' ).
    go_log->add_msgs( it_msg = gt_msgs ).
    go_log->save( ).
    COMMIT WORK AND WAIT.

  ENDIF.
