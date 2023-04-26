FUNCTION zfmtm_idoc_roadnet.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(MESSAGE_TYPE) LIKE  TBDME-MESTYP
*"----------------------------------------------------------------------
  CALL FUNCTION 'MASTERIDOC_CREATE_SMD_EQUI'
    EXPORTING
      i_message_type = message_type.
ENDFUNCTION.
