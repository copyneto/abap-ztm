*"* use this source file for any macro definitions you need
*"* in the implementation part of the class

DEFINE _fill_gko_header_from_xml.
  IF &3 = ''.
    gs_gko_header-&1 = get_value_from_xml( io_xslt_processor = go_xslt_processor
                                           iv_expression     = &2                ).
  ELSE.
    gs_gko_header-&1 = get_value_from_xml( io_xslt_processor = go_xslt_processor
                                           iv_expression     = &2                ).
    IF gs_gko_header-&1 IS INITIAL.
      gs_gko_header-&1 = get_value_from_xml( io_xslt_processor = go_xslt_processor
                                             iv_expression     = &3                ).
      IF gs_gko_header-&1 IS INITIAL AND &4 <> ''.
        gs_gko_header-&1 = get_value_from_xml( io_xslt_processor = go_xslt_processor
                                               iv_expression     = &4                ).
      ENDIF.
    ENDIF.
  ENDIF.
END-OF-DEFINITION.
