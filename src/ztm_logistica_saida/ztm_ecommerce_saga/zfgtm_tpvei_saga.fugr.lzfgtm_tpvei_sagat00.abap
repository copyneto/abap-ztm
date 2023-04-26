*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZVTM_TPVEI_SAGA.................................*
TABLES: ZVTM_TPVEI_SAGA, *ZVTM_TPVEI_SAGA. "view work areas
CONTROLS: TCTRL_ZVTM_TPVEI_SAGA
TYPE TABLEVIEW USING SCREEN '0001'.
DATA: BEGIN OF STATUS_ZVTM_TPVEI_SAGA. "state vector
          INCLUDE STRUCTURE VIMSTATUS.
DATA: END OF STATUS_ZVTM_TPVEI_SAGA.
* Table for entries selected to show on screen
DATA: BEGIN OF ZVTM_TPVEI_SAGA_EXTRACT OCCURS 0010.
INCLUDE STRUCTURE ZVTM_TPVEI_SAGA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTM_TPVEI_SAGA_EXTRACT.
* Table for all entries loaded from database
DATA: BEGIN OF ZVTM_TPVEI_SAGA_TOTAL OCCURS 0010.
INCLUDE STRUCTURE ZVTM_TPVEI_SAGA.
          INCLUDE STRUCTURE VIMFLAGTAB.
DATA: END OF ZVTM_TPVEI_SAGA_TOTAL.

*.........table declarations:.................................*
TABLES: ZTTM_TPVEI_SAGA                .
