***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Geração de Ordens de Frete para unidades de frete      *
*** AUTOR : Marcos Roberto de Souza - Meta                            *
*** FUNCIONAL: Marcio Mazzei - Meta                                   *
*** DATA : 12/01/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
REPORT ztmr_criar_ordem_frete.

DATA: gs_types TYPE /scmtms/c_torty,
      gs_tor   TYPE /scmtms/d_torrot,
      gs_likp  TYPE likp.
SELECT-OPTIONS: s_type  FOR gs_types-type,
                s_uf    FOR gs_tor-tor_id,
                s_vbeln FOR gs_likp-vbeln.

START-OF-SELECTION.

************************************************************************
**  Os logs deste job podem ser consultados através da transação SLG1 **
** ou app equivalente. O objeto é ZTM, e o subobjeto é ZOF            **
************************************************************************
  DATA(go_job) = NEW zcltm_process_of( ).
  go_job->execute( ir_tipos_fu = s_type[]
                   ir_num_fu   = s_uf[]
                   ir_remessas = s_vbeln[] ).

  go_job->show_log( ).
