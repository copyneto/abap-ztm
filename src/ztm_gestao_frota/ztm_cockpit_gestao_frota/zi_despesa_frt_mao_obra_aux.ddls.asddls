@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Despesas: Mão-de-obra (Parâmetro)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DESPESA_FRT_MAO_OBRA_AUX as select from ztca_param_val
{
    key modulo as Modulo,
    key case 
        when left(chave1,14) = cast('FRT_MAO_DE_OBRA' as abap.char( 14 )) then cast(left(chave1,15) as ze_param_chave)
        else chave1 end as Chave1,
    key chave2 as Chave2,
    key case
        when left(chave1,14) = cast('FRT_MAO_DE_OBRA' as abap.char( 14 )) then cast(right(chave1,4) as ze_param_chave_3)
        else chave3 end as Chave3,
    key sign as Sign,
    key opt as Opt,
    key low as Low,
    high as High,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
}
