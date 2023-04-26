@EndUserText.label: 'Projection Cockpit Tabelas Manutenção'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_TM_COCKPIT_TAB as projection on ZI_TM_COCKPIT_TAB {
    key Guid, 
    Tabela,
    Descricao,
    Hidden001,
    Hidden003,
    Hidden005,
    Hidden006,
    Hidden007,
    Hidden008,
    Hidden009,
    Hidden010,
    Hidden011,
    Hidden012,
    Hidden013,
    Hidden014,
    Hidden016,
    Hidden017,
    Hidden018,
    Hidden019,
    
    _001 : redirected to composition child ZC_TM_PCOCKPIT001,
    _003 : redirected to composition child ZC_TM_PCOCKPIT003,
    _005 : redirected to composition child ZC_TM_PCOCKPIT005,
    _006 : redirected to composition child ZC_TM_PCOCKPIT006,
    _007 : redirected to composition child ZC_TM_PCOCKPIT007,
    _008 : redirected to composition child ZC_TM_PCOCKPIT008,
    _009 : redirected to composition child ZC_TM_PCOCKPIT009,
    _010 : redirected to composition child ZC_TM_PCOCKPIT010,
    _011 : redirected to composition child ZC_TM_PCOCKPIT011,
    _012 : redirected to composition child ZC_TM_PCOCKPIT012,
    _013 : redirected to composition child ZC_TM_PCOCKPIT013,
    _014 : redirected to composition child ZC_TM_PCOCKPIT014,
    _016 : redirected to composition child ZC_TM_PCOCKPIT016,
    _017 : redirected to composition child ZC_TM_PCOCKPIT017,
    _018 : redirected to composition child ZC_TM_PCOCKPIT018,
    _019 : redirected to composition child ZC_TM_PCOCKPIT019
    
    
    
    
    
}
