*&---------------------------------------------------------------------*
*& Report  Z_TG_COMPARE_TABLE
*&---------------------------------------------------------------------*

REPORT z_tg_compare_table.

TYPES: BEGIN OF gts_string,
         lv_str           TYPE string,
       END OF gts_string.

TYPES: BEGIN OF gts_compare,
          lv_com_str      TYPE string,
          lv_index        LIKE sy-tabix,
       END OF gts_compare.

PARAMETERS: lp_usrin      TYPE i,
            lp_compt      RADIOBUTTON GROUP rb,
            lp_showt      RADIOBUTTON GROUP rb.

DATA: it_first_table      TYPE TABLE OF gts_string,
      it_second_table     TYPE TABLE OF gts_string,
      it_compare_table    TYPE TABLE OF gts_compare.

it_first_table = VALUE #(
                          ( lv_str = 'Lorem ipsum dolor sit amet'   )
                          ( lv_str = 'Consectetur adipiscing elit'  )
                          ( lv_str = 'Proin nibh augue, suscipit a, scelerisque sed'   )
                          ( lv_str = 'Etiam pellentesque aliquet tellus'  )
                          ( lv_str = 'Phasellus pharetra nulla ac diam'   )
                          ( lv_str = 'Quisque semper justo at risus'   )
                          ( lv_str = 'Donec venenatis, turpis vel hendrerit interdum'    )
                          ( lv_str = 'Nam congue, pede vitae dapibus aliquet'   )
                          ( lv_str = 'Etiam sit amet lectus quis est congue mollis'   )
                          ( lv_str = 'Phasellus congue lacus eget neque'   )
                          ( lv_str = 'Phasellus ornare, ante vitae consectetuer consequat'   )
                          ( lv_str = 'Praesent sodales velit quis augue' )
                        ).

it_second_table = VALUE #(
                          ( lv_str = 'Lorem ipsum dolor sit amet'   )
                          ( lv_str = 'Consectetur adipiscing elit'  )
                          ( lv_str = 'Proin nibh augue, suscipit a, scelerisque sed'   )
                          ( lv_str = 'Etiam pellentesque aliquet tellus'  )
                          ( lv_str = 'Phasellus pharetra nulla ac diam'   )
                          ( lv_str = 'Quisque semper justo at risus'   )
                          ( lv_str = 'Donec venenatis, turpis vel hendrerit interdum'    )
                          ( lv_str = 'Nam congue, pede vitae dapibus aliquet'   )
                          ( lv_str = 'Etiam sit amet lectus quis est congue mollis'   )
                          ( lv_str = 'Phasellus congue lacus eget neque'   )
                          ( lv_str = 'Phasellus ornare, ante vitae consectetuer consequat'   )
                          ( lv_str = 'Praesent sodales velit quis augue' )
                         ).


IF lp_compt = 'X'.
  PERFORM compare_tables.
ELSEIF  lp_showt = 'X'.
  PERFORM show_table.
ENDIF.

******************** BEGIN OF COMPARE TABLES ********************
FORM compare_tables.
  FIELD-SYMBOLS <wa_ft_record>  LIKE LINE OF it_first_table.
  FIELD-SYMBOLS <wa_st_record>  LIKE LINE OF it_second_table.
  FIELD-SYMBOLS <wa_com_record> LIKE LINE OF it_compare_table.

  DATA: lv_ft_rec LIKE LINE OF it_first_table,
        lv_st_rec LIKE lv_ft_rec,
        lv_itr    TYPE i.

  READ TABLE: it_first_table INDEX lp_usrin INTO lv_ft_rec.

  IF lines( it_first_table ) > lines( it_second_table ).
    lv_itr = lines( it_first_table ).
  ELSE.
    lv_itr = lines( it_second_table ).
  ENDIF.

  WRITE: 'I''m searching for', lp_usrin LEFT-JUSTIFIED, '. index ...', /.

  WHILE sy-index <= lv_itr.
    READ TABLE it_second_table INDEX sy-index INTO lv_st_rec.

    IF lv_ft_rec EQ lv_st_rec.
      WRITE: / 'Entry from first table', 'IS FOUND ' COLOR 5, 'on ', sy-index LEFT-JUSTIFIED, '       . index of second table.' LEFT-JUSTIFIED, /1 sy-uline(80).
    ELSE.
      WRITE: / 'Entry from first table', 'IS NOT FOUND ' COLOR 6, 'on ', sy-index LEFT-JUSTIFIED, '   . index of second table.' LEFT-JUSTIFIED, /1 sy-uline(80).
    ENDIF.
  ENDWHILE.
ENDFORM.
******************** END OF COMPARE TABLES ********************

******************** BEGIN OF SHOW TABLES ********************
FORM show_table.
  FIELD-SYMBOLS <wa_first_record>  LIKE LINE OF it_first_table.
  FIELD-SYMBOLS <wa_second_record> LIKE LINE OF it_second_table.

  IF lines( it_first_table ) > 0.
    WRITE: 'First table:'.
    LOOP AT it_first_table ASSIGNING <wa_first_record>.
      WRITE: / sy-index, <wa_first_record>-lv_str.
    ENDLOOP.
  ENDIF.

  SKIP 2.

  WRITE: 'Second table:'.
  IF lines( it_second_table ) > 0.
    LOOP AT it_second_table ASSIGNING <wa_second_record>.
      WRITE: / sy-index, <wa_second_record>-lv_str.
    ENDLOOP.
  ENDIF.

ENDFORM.
******************** END OF SHOW TABLES ********************
