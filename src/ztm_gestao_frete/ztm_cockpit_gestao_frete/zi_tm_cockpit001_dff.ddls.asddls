@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos DFF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_COCKPIT001_DFF
  as select from    zttm_gkot001              as gkot001

    left outer join ZI_TM_COCKPIT001_DOCDFF_A as dff_a on  dff_a.acckey = gkot001.acckey
                                                       and dff_a.tor_id = gkot001.tor_id

    left outer join ZI_TM_COCKPIT001_DOCDFF_U as dff_u on  dff_u.tor_id             = gkot001.tor_id
                                                       and dff_u.tpevento           = gkot001.tpevento
                                                       and dff_u.btd_id_127_estorno is initial

{
  key gkot001.acckey                         as acckey,

      case when dff_a.tor_id is not null
           then dff_a.tor_id 
           else dff_u.tor_id end             as tor_id,

      case when dff_a.db_key is not null
           then dff_a.db_key
           else dff_u.db_key end             as db_key,

      case when dff_a.ref_doc_nr_1 is not null
           then dff_a.ref_doc_nr_1
           else dff_u.ref_doc_nr_1 end       as ref_doc_nr_1,

      case when dff_a.tpevento is not null
           then dff_a.tpevento
           else dff_u.tpevento end           as tpevento,

      case when dff_a.wbeln is not null
           then dff_a.wbeln
           else dff_u.wbeln end              as wbeln,

      case when dff_a.sfir_id is not null
           then dff_a.sfir_id
           else dff_u.sfir_id end            as sfir_id,

      case when dff_a.sfir_key is not null
           then dff_a.sfir_key
           else dff_u.sfir_key end           as sfir_key,

      case when dff_a.lifecycle is not null
           then dff_a.lifecycle
           else dff_u.lifecycle end          as lifecycle,

      case when dff_a.confirmation is not null
           then dff_a.confirmation
           else dff_u.confirmation end       as confirmation,

      case when dff_a.btd_id_056 is not null
           then dff_a.btd_id_056
           else dff_u.btd_id_056 end         as btd_id_056,

      case when dff_a.btd_id_001 is not null
           then dff_a.btd_id_001
           else dff_u.btd_id_001 end         as btd_id_001,

      case when dff_a.btd_id_127 is not null
           then dff_a.btd_id_127
           else dff_u.btd_id_127 end         as btd_id_127,

      case when dff_a.btd_id_127_estorno is not null
           then dff_a.btd_id_127_estorno
           else dff_u.btd_id_127_estorno end as btd_id_127_estorno,

      case when dff_a.docnum is not null
           then dff_a.docnum
           else dff_u.docnum end             as docnum,

      case when dff_a.nfenum is not null
           then dff_a.nfenum
           else dff_u.nfenum end             as nfenum,

      case when dff_a.sakto is not null
           then dff_a.sakto
           else dff_u.sakto end              as sakto,

      case when dff_a.kostl is not null
           then dff_a.kostl
           else dff_u.kostl end              as kostl,

      case when dff_a.belnr_fin is not null
           then dff_a.belnr_fin
           else dff_u.belnr_fin end          as belnr_fin

}
