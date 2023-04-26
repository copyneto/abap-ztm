CLASS zcltm_mdf_emitente_ve DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcltm_mdf_emitente_ve IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT CONV string( 'COMPANYCODE' ) INTO TABLE et_Requested_orig_elements[].
    INSERT CONV string( 'BUSINESSPLACE' ) INTO TABLE et_Requested_orig_elements[].

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA:
      lt_emitente    TYPE STANDARD TABLE OF zi_tm_mdf_emitente,
      ls_address     TYPE sadr,
      ls_branch_data TYPE j_1bbranch,
      ls_address1    TYPE addr1_val,
      lv_cgc_number  TYPE j_1bcgc.

    lt_emitente = CORRESPONDING #( it_original_data ).

* --------------------------------------------------------------------
* Recupera informações
* --------------------------------------------------------------------
    LOOP AT lt_emitente REFERENCE INTO DATA(ls_emitente).

      CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
        EXPORTING
          branch            = ls_emitente->BusinessPlace
          bukrs             = ls_emitente->CompanyCode
        IMPORTING
          address           = ls_address
          branch_data       = ls_branch_data
          cgc_number        = lv_cgc_number
          address1          = ls_address1
        EXCEPTIONS
          branch_not_found  = 1
          address_not_found = 2
          company_not_found = 3
          OTHERS            = 4.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ls_emitente->cnpj                 = lv_cgc_number.

      CALL FUNCTION 'CONVERSION_EXIT_CGCBR_OUTPUT'
        EXPORTING
          input  = lv_cgc_number
        IMPORTING
          output = ls_emitente->CnpjText.

      ls_emitente->InscricaoEstadual    = ls_branch_data-state_insc.
      ls_emitente->NomeEmpresa          = ls_branch_data-name.
      ls_emitente->Endereco             = ls_address1-addrnumber.
      ls_emitente->Rua                  = ls_address1-street.
      ls_emitente->Numero               = ls_address1-house_num1.
      ls_emitente->Complemento          = ls_address1-house_num2.
      ls_emitente->Bairro               = ls_address1-city2.
      ls_emitente->TaxJurCode           = ls_address1-taxjurcode.
      ls_emitente->Cidade               = ls_address1-city1.
      ls_emitente->Cep                  = ls_address1-post_code1.

    ENDLOOP.

* --------------------------------------------------------------------
* Transfere dados convertidos
* --------------------------------------------------------------------
    ct_calculated_data = CORRESPONDING #( lt_emitente ).

  ENDMETHOD.


ENDCLASS.
