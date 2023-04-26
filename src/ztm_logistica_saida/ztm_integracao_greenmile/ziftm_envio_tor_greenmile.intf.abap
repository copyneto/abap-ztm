"!<p><h2>Interface para troca de informações entre action PPF e classe de envio Proxy</h2></p>
"!<p><strong>Autor: </strong>Marcos Roberto de Souza</p>
"!<p><strong>Data: </strong>10 de fev de 2022</p>
interface ZIFTM_ENVIO_TOR_GREENMILE
  public .


    "!Chamada à rotina de envio dos dados da ordem de frete
    "! @parameter iv_tor_key | Chave da ordem de frete
    "! @parameter et_messages | Mensagens durante o processamento da interface
  methods ENVIAR_TOR
    importing
      !IV_TOR_KEY type /BOBF/CONF_KEY
    exporting
      !EV_EXEC type FLAG
      !ET_MESSAGES type /SCMTMS/T_SYMSG .
endinterface.
