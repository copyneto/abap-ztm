@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface Cockpit Tabelas Manutenção'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TM_COCKPIT_TAB
  as select from zttm_cockpit_tab

  composition [0..*] of ZI_TM_PCOCKPIT001 as _001
  composition [0..*] of ZI_TM_PCOCKPIT003 as _003
  composition [0..*] of ZI_TM_PCOCKPIT005 as _005
  composition [0..*] of ZI_TM_PCOCKPIT006 as _006
  composition [0..*] of ZI_TM_PCOCKPIT007 as _007
  composition [0..*] of ZI_TM_PCOCKPIT008 as _008
  composition [0..*] of ZI_TM_PCOCKPIT009 as _009
  composition [0..*] of ZI_TM_PCOCKPIT010 as _010
  composition [0..*] of ZI_TM_PCOCKPIT011 as _011
  composition [0..*] of ZI_TM_PCOCKPIT012 as _012
  composition [0..*] of ZI_TM_PCOCKPIT013 as _013
  composition [0..*] of ZI_TM_PCOCKPIT014 as _014
  composition [0..*] of ZI_TM_PCOCKPIT016 as _016
  composition [0..*] of ZI_TM_PCOCKPIT017 as _017
  composition [0..*] of ZI_TM_PCOCKPIT018 as _018
  composition [0..*] of ZI_TM_PCOCKPIT019 as _019 

{
  key guid      as Guid,
      tabela    as Tabela,
      descricao as Descricao,

      case tabela
      when 'ZTTM_PCOCKPIT001' then ''
      else 'X'
      end       as Hidden001,
      
            case tabela
      when 'ZTTM_PCOCKPIT003' then ''
      else 'X'
      end       as Hidden003,
      
                  case tabela
      when 'ZTTM_PCOCKPIT005' then ''
      else 'X'
      end       as Hidden005,
      
                  case tabela
      when 'ZTTM_PCOCKPIT006' then ''
      else 'X'
      end       as Hidden006,
      
                  case tabela
      when 'ZTTM_PCOCKPIT007' then ''
      else 'X'
      end       as Hidden007,
      
                  case tabela
      when 'ZTTM_PCOCKPIT008' then ''
      else 'X'
      end       as Hidden008,
      
                  case tabela
      when 'ZTTM_PCOCKPIT009' then ''
      else 'X'
      end       as Hidden009,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT010' then ''
      else 'X'
      end       as Hidden010,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT011' then ''
      else 'X'
      end       as Hidden011,        
      
                  case tabela
      when 'ZTTM_PCOCKPIT012' then ''
      else 'X'
      end       as Hidden012,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT013' then ''
      else 'X'
      end       as Hidden013,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT014' then ''
      else 'X'
      end       as Hidden014,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT016' then ''
      else 'X'
      end       as Hidden016,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT017' then ''
      else 'X'
      end       as Hidden017,            
      
                  case tabela
      when 'ZTTM_PCOCKPIT018' then ''
      else 'X'
      end       as Hidden018,            
                
                  case tabela
      when 'ZTTM_PCOCKPIT019' then ''
      else 'X'
      end       as Hidden019,


      _001,
      _003,
      _005,
      _006,
      _007,
      _008,
      _009,
      _010,
      _011,
      _012,
      _013,
      _014,
      _016,
      _017,
      _018,
      _019
}
