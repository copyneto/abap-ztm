@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface Tabela 017'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_PCOCKPIT017
  as select from zttm_pcockpit017
  association to ZI_TM_VH_ID_CENARIO      as _CONFID    on _CONFID.DomvalueL = $projection.Operacao
  association to ZI_TM_VH_GRP_COMPRADORES as _GrpComp   on _GrpComp.ekgrp = $projection.Ekgrp
  association to ZI_TM_VH_TPMATERIAL      as _TpMat     on _TpMat.mtart = $projection.Mtart
  association to ZI_TM_VH_TPDOCCOMP       as _TpDocComp on _TpDocComp.bsart = $projection.Bsart
  association to parent ZI_TM_COCKPIT_TAB as _Cockpit   on _Cockpit.Guid = $projection.Guid
{
  key    guid                      as Guid,
  key    guid17                    as Guid17,
  key    bsart                     as Bsart,
         ekgrp                     as Ekgrp,
         mtart                     as Mtart,

         forn_ext                  as FornExt,
         emp_grupo                 as EmpGrupo,
         operacao                  as Operacao,
         tipooperacao,
         manual,
         iva,
         icms_xml,

         _Cockpit,

         //Associações
         _CONFID.Text              as TextoCenario,
         _GrpComp.Descricao        as TextoGrp,
         _TpMat.mtart_txt          as TextoTpMat,
         _TpDocComp.TextoTpDocComp as TextoTpDocComp
}
