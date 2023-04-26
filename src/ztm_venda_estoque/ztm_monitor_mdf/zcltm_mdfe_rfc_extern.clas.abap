class ZCLTM_MDFE_RFC_EXTERN definition
  public
  final
  create public .

public section.

  interfaces /XNFE/IF_BADI_MDFE_RFC_EXTERN .
  interfaces IF_BADI_INTERFACE .
protected section.
private section.
ENDCLASS.



CLASS ZCLTM_MDFE_RFC_EXTERN IMPLEMENTATION.


  method /XNFE/IF_BADI_MDFE_RFC_EXTERN~MDFE_RFC_EXTERN_CALL.
    CV_MDFE_RFC_EXT = ABAP_TRUE.
  endmethod.
ENDCLASS.
