interface ZII_SI_RECEBER_EVENTO_ROTA_GM
  public .


  methods SI_RECEBER_EVENTO_ROTA_GM_IN
    importing
      !INPUT type ZMT_ROTA_GM
    raising
      ZCX_FMT_ROTA_GM .
endinterface.
