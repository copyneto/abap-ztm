*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* Constantes globais
* ===========================================================================
  CONSTANTS:
    BEGIN OF gc_status_event,
      coletado     TYPE /scmtms/tor_event VALUE 'COLETADO',
      devolvido    TYPE /scmtms/tor_event VALUE 'DEVOLVIDO',
      entregue     TYPE /scmtms/tor_event VALUE 'ENTREGUE',
      nao_coletado TYPE /scmtms/tor_event VALUE 'NÃO COLETADO',
      pendente     TYPE /scmtms/tor_event VALUE 'PENDENTE',
      sinistro     TYPE /scmtms/tor_event VALUE 'SINISTRO',
    END OF gc_status_event,

    BEGIN OF gc_param_auart,
      modulo TYPE ztca_param_val-modulo VALUE 'TM' ##NO_TEXT,
      chave1 TYPE ztca_param_val-chave1 VALUE 'PRESTACAO_CONTAS' ##NO_TEXT,
      chave2 TYPE ztca_param_val-chave2 VALUE 'AUART' ##NO_TEXT,
      chave3 TYPE ztca_param_val-chave3 VALUE '' ##NO_TEXT,
    END OF gc_param_auart.

  CONSTANTS gc_ad_print_vics_man TYPE string VALUE '/SCMTMS/PRINT_VICS_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_vics TYPE string VALUE '/SCMTMS/PRINT_VICS' ##NO_TEXT.
  CONSTANTS gc_ad_print_cmr TYPE string VALUE '/SCMTMS/PRINT_CMR' ##NO_TEXT.
  CONSTANTS gc_ad_print_fbl TYPE string VALUE '/SCMTMS/PRINT_FBL' ##NO_TEXT.
  CONSTANTS gc_ad_print_ffi TYPE string VALUE '/SCMTMS/PRINT_FFI' ##NO_TEXT.
  CONSTANTS gc_ad_print_hawb TYPE string VALUE '/SCMTMS/PRINT_HAWB' ##NO_TEXT.
  CONSTANTS gc_ad_print_hbl TYPE string VALUE '/SCMTMS/PRINT_HBL' ##NO_TEXT.
  CONSTANTS gc_ad_print_lab TYPE string VALUE '/SCMTMS/PRINT_LAB' ##NO_TEXT.
  CONSTANTS gc_ad_print_man TYPE string VALUE '/SCMTMS/PRINT_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_mawb TYPE string VALUE '/SCMTMS/PRINT_MAWB' ##NO_TEXT.
  CONSTANTS gc_ad_print_mbl TYPE string VALUE '/SCMTMS/PRINT_MBL' ##NO_TEXT.
  CONSTANTS gc_ad_print_packlist TYPE string VALUE '/SCMTMS/PRINT_PACKLIST' ##NO_TEXT.
  CONSTANTS gc_ad_print_cmr_man TYPE string VALUE '/SCMTMS/PRINT_CMR_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_fbl_man TYPE string VALUE '/SCMTMS/PRINT_FBL_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_ffi_man TYPE string VALUE '/SCMTMS/PRINT_FFI_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_hawb_man TYPE string VALUE '/SCMTMS/PRINT_HAWB_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_hbl_man TYPE string VALUE '/SCMTMS/PRINT_HBL_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_lab_man TYPE string VALUE '/SCMTMS/PRINT_LAB_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_man_man TYPE string VALUE '/SCMTMS/PRINT_MAN_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_mawb_man TYPE string VALUE '/SCMTMS/PRINT_MAWB_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_mbl_man TYPE string VALUE '/SCMTMS/PRINT_MBL_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_mawb_label TYPE string VALUE '/SCMTMS/PRINT_MAWB_LABEL' ##NO_TEXT.
  CONSTANTS gc_ad_print_manifest_addr TYPE string VALUE '/SCMTMS/PRINT_CARGO_MAN_ADDR' ##NO_TEXT.
  CONSTANTS gc_ad_print_manifest TYPE string VALUE '/SCMTMS/PRINT_CARGO_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_sec_manifest TYPE string VALUE '/SCMTMS/PRINT_SEC_MANIFEST' ##NO_TEXT.
  CONSTANTS gc_ad_print_hawb_fu TYPE string VALUE '/SCMTMS/PRINT_HAWB_FU' ##NO_TEXT.
  CONSTANTS gc_ad_print_hawb_man_fu TYPE string VALUE '/SCMTMS/PRINT_HAWB_MAN_FU' ##NO_TEXT.
  CONSTANTS gc_ad_print_comb_label TYPE string VALUE '/SCMTMS/PRINT_COMB_LABEL' ##NO_TEXT.
  CONSTANTS gc_ad_print_load_plan TYPE string VALUE '/SCMTMS/PRINT_LOAD_PLAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_uld_manifest TYPE string VALUE '/SCMTMS/PRINT_ULD_MANIFEST' ##NO_TEXT.
  CONSTANTS gc_ad_print_uld_tag TYPE string VALUE '/SCMTMS/PRINT_ULD_TAG' ##NO_TEXT.
  CONSTANTS gc_ad_print_airport_transfer TYPE string VALUE '/SCMTMS/PRINT_AIRPORT_TRANSFER' ##NO_TEXT.
  CONSTANTS gc_ad_print_truck_manifest TYPE string VALUE '/SCMTMS/PRINT_TRUCK_MANIFEST' ##NO_TEXT.
  CONSTANTS gc_ad_print_pickup_order TYPE string VALUE '/SCMTMS/PRINT_PICKUP_ORDER' ##NO_TEXT.
  CONSTANTS gc_ad_print_delivery_order TYPE string VALUE '/SCMTMS/PRINT_DELIVERY_ORDER' ##NO_TEXT.
  CONSTANTS gc_ad_print_hawb_label TYPE string VALUE '/SCMTMS/PRINT_HAWB_LABEL_FU' ##NO_TEXT.
  CONSTANTS gc_ad_print_mbli TYPE string VALUE '/SCMTMS/PRINT_MBLI' ##NO_TEXT.
  CONSTANTS gc_ad_print_mbli_man TYPE string VALUE '/SCMTMS/PRINT_MBLI_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_create_fwsd TYPE string VALUE '/SCMTMS/CREATE_FWSD_AIR' ##NO_TEXT.
  CONSTANTS gc_ad_print_parcel_man TYPE string VALUE '/SCMTMS/PRINT_PARCEL_MAN' ##NO_TEXT.
  CONSTANTS gc_ad_print_parcel_lbl_all TYPE string VALUE '/SCMTMS/PRINT_PARCEL_LBL_ALL' ##NO_TEXT.
  CONSTANTS gc_ad_print_shprs_dcl TYPE string VALUE '/SCMTMS/PRINT_SHPRS_DCL' ##NO_TEXT.
  CONSTANTS gc_ad_print_loadplan_air TYPE string VALUE '/SCMTMS/PRINT_LOADPLAN_AIR' ##NO_TEXT.
  CONSTANTS gc_ad_print_loadplan_road TYPE string VALUE '/SCMTMS/PRINT_LOADPLAN_ROAD' ##NO_TEXT.
  CONSTANTS gc_ad_print_loadplan_sea TYPE string VALUE '/SCMTMS/PRINT_LOADPLAN_SEA' ##NO_TEXT.
