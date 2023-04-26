"Name: \TY:CL_MRM_TM_SERVICES\ME:DETERMINE_TM_RELEVANCE\SE:BEGIN\EI
ENHANCEMENT 0 ZEIMM_COCKPIT_FRETE_MIRO.

* ---------------------------------------------------------------------------------
* Indica que o documento é TM, ou seja, força qualquer pedido para ser usado na MIRO de TM e pular a
* mensagem: Documento compras 4500007382 provém de SAP TM, seleção não possível
* ---------------------------------------------------------------------------------
* OBS: Descomentamos o código abaixo, pois dá problema lá na frente.
* ---------------------------------------------------------------------------------
* if IS_EKKO-STATU = CO_STATU_TM.
*      CV_XTM = CO_TRUE.
*      EXIT.
* endif.

ENDENHANCEMENT.
