*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTFM_MDF_STAT...................................*
DATA:  BEGIN OF STATUS_ZTFM_MDF_STAT                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTFM_MDF_STAT                 .
CONTROLS: TCTRL_ZTFM_MDF_STAT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTFM_MDF_STAT                 .
TABLES: ZTFM_MDF_STAT                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
