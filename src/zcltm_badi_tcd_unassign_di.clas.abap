class ZCLTM_BADI_TCD_UNASSIGN_DI definition
  public
  final
  create public .

public section.

  interfaces /SCMTMS/IF_COMMON_BADI .
  interfaces /SCMTMS/IF_TCD_UPDATE_DI .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_BADI_TCD_UNASSIGN_DI IMPLEMENTATION.


METHOD /SCMTMS/IF_COMMON_BADI~SET_BADI_WORK_MODE.
ENDMETHOD.


METHOD /SCMTMS/IF_TCD_UPDATE_DI~UNASSIGN_DI.

*  The Example Implementation illustrates how to delete a service distribution item, so that no charge is allocated to it. And the charge
*  which belongs to this item will be automatically redistributed to other distribution items based on standard redistribution logic.

*  Here is an explanation of the sample implementation, w.r.t each comment provided in the code.

* Loop 1: This is a Loop at distribution Item. A distribution item refers to either an ERP Item or Forwarding order based on distribution
* level settings. In this case it points to ERP Item.
* Read 1: This is to read the communication structure instance. An instance contains the Document Information. In this case the assumption is
* a freight document. The key for freight document is stored in ref_root_key of distribution item.
* Read 2: This is to read the Freight Document Item stored in the communication structure instance. Distribution Item ref_key points to a
* freight document item which is the ERP Item.
* Check for deletion condition: In this sample implementation, the service items which are coming from ERP document, but are not relevant for
* distribution are given a description of 'SERVICE'. And with this check we are specifying that this are invalid distribution items.



  FIELD-SYMBOLS:
                 <ls_distr_item> TYPE /scmtms/s_tcd_distr_item_k,
                 <ls_distr_root> TYPE /scmtms/s_tcd_root_k,
                 <ls_tcd_comm_root> TYPE /scmtms/s_tcd_comm_root,
                 <ls_tcd_comm_item> TYPE /scmtms/s_tcd_comm_item,
                 <ls_key>           TYPE /bobf/s_frw_key.

* Loop 1.
  LOOP AT it_distr_item ASSIGNING <ls_distr_item>.
* Read 1.
    READ TABLE it_tcd_comm_root ASSIGNING <ls_tcd_comm_root> WITH KEY key COMPONENTS key = <ls_distr_item>-ref_root_key.
    IF sy-subrc = 0.
* Read 2.
      READ TABLE <ls_tcd_comm_root>-item ASSIGNING <ls_tcd_comm_item> WITH KEY key COMPONENTS key = <ls_distr_item>-ref_key.
      IF sy-subrc = 0.
* Check for deletion condition.
        IF <ls_tcd_comm_item>-item_descr = 'SERVICE'.
          APPEND INITIAL LINE TO ct_invalid_di_key ASSIGNING <ls_key>.
          <ls_key>-key = <ls_distr_item>-key.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
ENDMETHOD.
ENDCLASS.
