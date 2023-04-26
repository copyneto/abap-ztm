"Name: \TY:CL_WDR_CLIENT_ABSTRACT_HTTP\IN:IF_WDR_CLIENT\ME:ATTACH_FILE_TO_RESPONSE\SE:BEGIN\EI
ENHANCEMENT 0 ZEITM_PREVIEW_OT.

"Correção para que a previsualização de impressões no padrão smartforms possa funcionar
"corretamente.

IF i_mime_type IS INITIAL AND ( i_filename = 'ZSFTM_CONF_ENTREGA_MERCADORIA' OR
                                i_filename = 'ZSFTM_TRANSPORTE_ITINERARIO' ).
  i_mime_type = 'application/pdf'.
ENDIF.

ENDENHANCEMENT.
