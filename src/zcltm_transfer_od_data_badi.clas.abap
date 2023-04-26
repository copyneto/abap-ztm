class ZCLTM_TRANSFER_OD_DATA_BADI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_WZRE_TRANSFER_OD_DATA_BADI .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_TRANSFER_OD_DATA_BADI IMPLEMENTATION.


  method IF_WZRE_TRANSFER_OD_DATA_BADI~TRANSFER.
    RETURN.
  endmethod.
ENDCLASS.
