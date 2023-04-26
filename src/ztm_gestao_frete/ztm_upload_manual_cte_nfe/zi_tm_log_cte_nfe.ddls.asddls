@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Log upload CTe NFe'
define root view entity ZI_TM_LOG_CTE_NFE
  as select from zttm_log_cte_nfe as Log

  association [0..1] to ZI_TM_VH_DOCTYPE_CTE_NFE as _Doctype       on _Doctype.Doctype = $projection.Doctype
  association [0..1] to ZI_TM_VH_STATUS_CTE_NFE  as _Status        on _Status.Status = $projection.Status
  association [0..1] to ZI_CA_VH_USER            as _CreatedBy     on _CreatedBy.Bname = $projection.CreatedBy
  association [0..1] to ZI_CA_VH_USER            as _LastChangedBy on _LastChangedBy.Bname = $projection.LastChangedBy
{
  key guid                             as Guid,
      doctype                          as Doctype,
      _Doctype.DoctypeText             as DoctypeText,

      case doctype when '1' then 3
                   when '2' then 2
                            else 0 end as DoctypeCrit,

      status                           as Status,
      _Status.StatusText               as StatusText,


      case status when 'S' then 3
                  when 'E' then 1
                  when 'W' then 2
                           else 0 end  as StatusCrit,

      message                          as Message,
      filename                         as Filename,
      documenttype                     as Documenttype,
      documentnumber                   as Documentnumber,
      documentversion                  as Documentversion,
      documentpart                     as Documentpart,
      created_by                       as CreatedBy,
      _CreatedBy.Text                  as CreatedByName,
      created_at                       as CreatedAt,
      last_changed_by                  as LastChangedBy,
      _LastChangedBy.Text              as LastChangedByName,
      last_changed_at                  as LastChangedAt,
      local_last_changed_at            as LocalLastChangedAt

}
