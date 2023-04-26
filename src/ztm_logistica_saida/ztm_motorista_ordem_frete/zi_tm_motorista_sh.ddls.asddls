@AbapCatalog.sqlViewName: 'ZVTM_MOTORISTA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search-help para motorista'
define view zi_tm_motorista_sh 
  as select from    but000       as Master
    inner join      dfkkbptaxnum as Slave on  Slave.partner = Master.partner
                                          and Slave.taxtype = 'BR2'
    inner join but0id       as Id    on  Id.partner         = Master.partner //left outer join
                                          and Id.type            = 'ZCNH'
//                                          and Id.valid_date_from <= $session.system_date
//                                          and Id.valid_date_to   >= $session.system_date
{
  key cast(Master.partner as ze_motorista preserving type )                                                as CodigoMotorista,
      @EndUserText.label: 'Nome do Motorista'
      cast(concat( Master.name_first, concat(' ', Master.name_last)) as ze_nome_motorista preserving type) as NomeMotorista,
      @EndUserText.label: 'CPF'
      cast(left(Slave.taxnum,11) as ze_cpf preserving type)                                                as CPF,
      Id.idnumber                                                                                          as RegistroCNH,
      Id.valid_date_to                                                                                     as Validade     

}
where
      Master.xdele        = ''
  and Master.not_released = ''
  and Master.xblck        = ''
  and Master.bpkind       = '0011'
//  and Id.valid_date_from <= $session.system_date
//  and Id.valid_date_to   >= $session.system_date
