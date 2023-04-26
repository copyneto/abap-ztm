@AbapCatalog.sqlViewName: 'ZVMM_GKODOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dados para criação de MIRO'
define view ZI_MM_GET_GKO_DOC
  as select from    ZI_TM_COCKPIT001      as _001

    left outer join ekko                  as _PO     on _PO.ebeln = _001.Pedido

    left outer join j_1bbranch            as _Branch on  _Branch.stcd1      = _001.tom_cnpj_cpf
                                                     and _Branch.state_insc = _001.tom_ie
    left outer join t001w                 as _Centro on  _Centro.j_1bbranch = _Branch.branch
                                                     and _Centro.regio      = _001.tom_uf
    left outer join lfa1                  as _Forn   on _Forn.lifnr = _001.emit_cod
    left outer join zttm_pcockpit012      as _012    on  _012.tpdoc = _001.tpdoc
                                                     and _012.model = _001.model
    left outer join ZI_MM_GET_GKO_DOC_010 as _010    on _010.acckey = _001.acckey
    left outer join /xnfe/inctehd         as _CTE    on _CTE.cteid = _001.acckey
    left outer join /xnfe/innfehd         as _NFE    on _NFE.nfeid = _001.acckey
{
  _001.acckey,
  _001.tor_id,
  _001.codstatus,
  _001.tpdoc,
  _001.tpcte,
  _001.bukrs,
  _PO.bukrs            as po_bukrs,
  _001.branch,
  _001.dtemi,
  _001.hremi,
  _001.model,
  _001.nfnum9,
  _001.series,
  _001.prefno,
  _001.emit_cod,
  _001.tom_cnpj_cpf,
  _001.tom_ie,
  _001.tom_uf,
  _001.SupplierInvoice as re_belnr,
  _001.FiscalYear      as re_gjahr,
  _001.vtprest,
  _001.vrec,
  _001.Pedido          as ebeln,
  _001.lblni,
  _PO.zterm,
  _Forn.lifnr,
  _Forn.crtn,

  case _001.tpdoc
  when 'CTE' then _012.nftype
  when 'NFE' then _010.nftype
  when 'NFS' then _010.nftype
  else cast( '' as ze_j_1bnfetype )
  end                  as nftype,

  _Centro.werks,
  _NFE.nprot           as nfe_nprot,
  _NFE.dhemi           as nfe_dhemi,
  _CTE.nprot           as cte_nprot,
  _CTE.dhemi           as cte_dhemi,

  case when _001.nfnum9 is not initial and _001.tpdoc <> 'NFS'
       then cast( concat( right( lpad( _001.nfnum9, 20, '0'), 9),
                  concat( '-', lpad( _001.series, 3, '0') ) ) as xblnr )
       when _001.nfnum9 is not initial and _001.tpdoc = 'NFS'
       then cast( concat( right( lpad( _001.nfnum9, 20, '0'), 6),
                  concat( '-', lpad( _001.series, 3, '0') ) ) as xblnr )

       when _001.prefno is not initial and _001.tpdoc <> 'NFS'
       then cast( concat( right( lpad( _001.prefno, 20, '0'), 9),
                  concat( '-', lpad( _001.series, 3, '0') ) ) as xblnr )
       when _001.prefno is not initial and _001.tpdoc = 'NFS'
       then cast( concat( right( lpad( _001.prefno, 20, '0'), 6),
                  concat( '-', lpad( _001.series, 3, '0') ) ) as xblnr )

       else cast( concat( substring( _001.acckey, 26, 9),
                  concat( '-', substring( _001.acckey, 23, 3) ) ) as xblnr )

  end                  as xblnr,
  _010.sakto           as sakto,
  _001.lifecycle       as lifecycle,
  _001.confirmation    as confirmation

}
group by
  _001.acckey,
  _001.tor_id,
  _001.codstatus,
  _001.tpdoc,
  _001.tpcte,
  _001.bukrs,
  _PO.bukrs,
  _001.branch,
  _001.dtemi,
  _001.hremi,
  _001.model,
  _001.nfnum9,
  _001.series,
  _001.prefno,
  _001.emit_cod,
  _001.tom_cnpj_cpf,
  _001.tom_ie,
  _001.tom_uf,
  _001.SupplierInvoice,
  _001.FiscalYear,
  _001.vtprest,
  _001.vrec,
  _001.Pedido,
  _001.lblni,
  _PO.zterm,
  _Forn.lifnr,
  _Forn.crtn,
  _012.nftype,
  _010.nftype,
  _Centro.werks,
  _NFE.nprot,
  _NFE.dhemi,
  _CTE.nprot,
  _CTE.dhemi,
  _010.sakto,
  _001.lifecycle,
  _001.confirmation
