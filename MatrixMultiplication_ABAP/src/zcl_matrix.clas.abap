class ZCL_MATRIX definition
  public
  final
  create public .

public section.

  data M type INT4 .
  data N type INT4 .
  data MATRIX type ZTMATRIX .

  methods CONSTRUCTOR
    importing
      !IV_M type INT4
      !IV_N type INT4 .
  methods CREATE_RANDOM_MATRIX .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MATRIX IMPLEMENTATION.


  method CONSTRUCTOR.
    DATA:
      lv_i    TYPE i VALUE 1,
      lv_j    TYPE i VALUE 1,
      ls_line TYPE zsmatrix.

    FIELD-SYMBOLS:
                   <fs_line> TYPE zsmatrix.
    ASSIGN ls_line TO <fs_line>.

    me->m = iv_m.
    me->n = iv_n.

    WHILE lv_i <= iv_m.
      WHILE lv_j <= iv_n.
        <fs_line>-m = lv_i.
        <fs_line>-n = lv_j.
        INSERT <fs_line> INTO TABLE me->matrix.
        lv_j = lv_j + 1.
      ENDWHILE.
      lv_j = 1.
      lv_i = lv_i + 1.
    ENDWHILE.
  endmethod.


  method CREATE_RANDOM_MATRIX.
    FIELD-SYMBOLS:
               <fs_line> TYPE zsmatrix.

    LOOP AT me->matrix ASSIGNING <fs_line>.
      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max = 10
          ran_int_min = 0
        IMPORTING
          ran_int = <fs_line>-value.
    ENDLOOP.
  endmethod.
ENDCLASS.
