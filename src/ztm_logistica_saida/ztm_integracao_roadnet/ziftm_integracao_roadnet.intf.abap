"!<p><h2>Interface de Integração com o Roadnet</h2></p>
"!<p>A utilização desta interface é realizada na custom entity ZC_TM_PARAM_ROADNET. A implementação deve ser feita na business class relativa à
"! interface de saída para solicitar a atualização das rotas pelo Roadnet</p>
"!<p><strong>Autor:</strong>Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong>26 de jan de 2022</p>
INTERFACE ziftm_integracao_roadnet
  PUBLIC .


  "! Execução da interface baseada nos parâmetros definidos
  "! @parameter iv_centro | Centro de planejamento
  "! @parameter iv_data | Data do planejamento
  "! @parameter iv_sessao | Código da sessão do Roadnet (pode estar vazio, neste caso todas as sessões do dia devem ser retornadas)
  "! @parameter et_messages | Mensagens de erro da execução da interface
  METHODS executar
    IMPORTING
      !iv_centro         TYPE werks_d
      !iv_data           TYPE sydatum
      VALUE(iv_data_ate) TYPE sydatum OPTIONAL
      !iv_sessao         TYPE zttm_road_sessio-id_session_roadnet
      !iv_testrun        TYPE flag DEFAULT abap_false
    EXPORTING
      !et_road_session   TYPE zctgtm_road_session
      !et_road_item      TYPE zctgtm_road_item
      !et_road_log       TYPE zctgtm_road_log
      !et_messages       TYPE bapiret2_t.
ENDINTERFACE.
