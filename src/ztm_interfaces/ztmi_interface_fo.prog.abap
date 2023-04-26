***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Integração GKO/GM/Trafegus - Status Faturamento        *
*** AUTOR : Rafael Portes - Meta                                      *
*** FUNCIONAL: Wellington Oliveira - Meta                             *
*** DATA : 28/02/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR   | DESCRIÇÃO                                   *
***-------------------------------------------------------------------*
*** 28/02/2023| RPORTES | Codificação inicial                         *
***********************************************************************

*  DATA(lo_tor) = NEW zcltm_interface_fo( ).
*  lo_tor->set_status_invoicing( is_header ).

CALL FUNCTION 'ZFMTM_INTERFACES'
  STARTING NEW TASK 'ZFMTM_INTERFACES'
  EXPORTING
    is_header = is_header.
