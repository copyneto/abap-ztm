@AbapCatalog.sqlViewName: 'ZITM_TOR1'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS com tabelas do BOPF /SCMTMS/TOR'
define view ZI_TM_BOPF_TOR
  as select from    /scmtms/d_torstp as _Stop
    left outer join /scmtms/d_torrot as _TorRoot     on _Stop.parent_key = _TorRoot.db_key
    left outer join /scmtms/d_tordrf as _DocumentRef on _TorRoot.db_key = _DocumentRef.parent_key
{

  key  _TorRoot.db_key                  as ParentKey,
       _TorRoot.tor_id,
       _Stop.log_locid                  as UG,
       _DocumentRef.origin,

       _Stop.plan_trans_time            as DataPlanejada,

       _Stop.stop_cat,
       _Stop.stop_seq_pos,
       _TorRoot.tor_cat,

       _DocumentRef.btd_id,
       _DocumentRef.btd_tco

}
