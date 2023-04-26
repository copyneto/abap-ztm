class ZCL_IM_TM_PPF_CONDEXE_GM definition
  public
  final
  create public .

public section.

  interfaces IF_EX_EVAL_STARTCOND_PPF .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_TM_PPF_CONDEXE_GM IMPLEMENTATION.


  method IF_EX_EVAL_STARTCOND_PPF~EVALUATE_START_CONDITION.
    EP_RC = 0.
  endmethod.
ENDCLASS.
