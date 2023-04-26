@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Fretes - Último log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TM_MONITOR_GKO_LOG_LAST
  as select from ZI_TM_MONITOR_GKO_LOG as UltimoLog

  association [0..1] to ZI_TM_MONITOR_GKO_LOG as _Log on  _Log.acckey  = $projection.acckey
                                                      and _Log.counter = $projection.counter
{
  key UltimoLog.acckey         as acckey,
      max( UltimoLog.counter ) as counter,
      _Log 
 
}
//where
//  UltimoLog.codigo is not initial
group by
  UltimoLog.acckey
