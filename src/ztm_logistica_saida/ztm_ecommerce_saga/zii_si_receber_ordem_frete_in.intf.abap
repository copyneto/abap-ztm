interface ZII_SI_RECEBER_ORDEM_FRETE_IN
  public .


  methods SI_RECEBER_ORDEM_FRETE_IN
    importing
      !INPUT type ZMT_FRETE_ORDEM
    raising
      ZCX_FMT_FRETE_ORDEM .
endinterface.
