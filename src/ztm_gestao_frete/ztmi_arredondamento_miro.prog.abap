*&---------------------------------------------------------------------*
*& Include          ZTMI_ARREDONDAMENTO_MIRO
*&---------------------------------------------------------------------*

 CONSTANTS: gc_taxgrp_icms TYPE  j_1baj-taxgrp VALUE 'ICMS'.

 DATA(ls_gko_item_arredondamento) = VALUE zcltm_gko_process=>ty_s_item_arredondamento( ).
 IMPORT item_arredondamento TO ls_gko_item_arredondamento FROM MEMORY ID zcltm_gko_process=>gc_memory_id-item_arredondamento.

 IF ls_gko_item_arredondamento IS NOT INITIAL AND i_komp-evrtn = ls_gko_item_arredondamento-ebeln
                                              AND i_komp-evrtp = ls_gko_item_arredondamento-ebelp.
   IF it_komv IS NOT INITIAL.
     SELECT taxtyp
       FROM j_1baj
       INTO TABLE @DATA(lt_j_1baj)
       FOR ALL ENTRIES IN @it_komv
       WHERE   taxtyp      = @it_komv-kschl
         AND   taxgrp      = @gc_taxgrp_icms
         AND ( subdivision = @space
         OR    subdivision IS NULL  ).

     IF sy-subrc IS INITIAL.

       READ TABLE lt_j_1baj ASSIGNING FIELD-SYMBOL(<fs_s_j_1baj>) INDEX 1.
       IF sy-subrc IS INITIAL.

         DATA(lt_komv) = it_komv.
         SORT lt_komv BY kschl.

         READ TABLE lt_komv ASSIGNING FIELD-SYMBOL(<fs_s_komv>) WITH KEY kschl = <fs_s_j_1baj>-taxtyp BINARY SEARCH.
         IF sy-subrc IS INITIAL.

           <fs_s_komv>-kawrt = <fs_s_komv>-kawrt + ls_gko_item_arredondamento-diferenca.
           <fs_s_komv>-kwert = <fs_s_komv>-kwert + ls_gko_item_arredondamento-diferenca.

         ENDIF.

       ENDIF.

     ENDIF.

   ENDIF.
 ENDIF.
