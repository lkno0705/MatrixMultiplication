*&---------------------------------------------------------------------*
*& Report Z_MATRIXMULT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_MATRIXMULT.

PARAMETERS:
      p_m TYPE i DEFAULT 200,
      p_n TYPE i DEFAULT 200.

DATA:
      lv_start_regular  TYPE i,
      lv_end_regular    TYPE i,
      lv_difference     TYPE decfloat34,
      lo_matrix_a       TYPE REF TO zcl_matrix,
      lo_matrix_b       TYPE REF TO zcl_matrix,
      lo_matrix_c       TYPE REF TO zcl_matrix.

FIELD-SYMBOLS:
               <fs_line_a> TYPE zsmatrix,
               <fs_line_b> TYPE zsmatrix,
               <fs_line_c> TYPE zsmatrix.

START-OF-SELECTION.

CREATE OBJECT:
  lo_matrix_a
    EXPORTING
      iv_m = p_m
      iv_n = p_n,
  lo_matrix_b
    EXPORTING
      iv_m = p_m
      iv_n = p_n,
  lo_matrix_c
    EXPORTING
      iv_m = p_m
      iv_n = p_n.

CALL METHOD:
             lo_matrix_a->create_random_matrix,
             lo_matrix_b->create_random_matrix.

GET RUN TIME FIELD lv_start_regular.

LOOP AT lo_matrix_c->matrix ASSIGNING <fs_line_c>.
  LOOP AT lo_matrix_a->matrix ASSIGNING <fs_line_a> USING KEY m_sort WHERE m = <fs_line_c>-m.
    READ TABLE lo_matrix_b->matrix WITH KEY primary_key COMPONENTS m = <fs_line_a>-n n = <fs_line_c>-n ASSIGNING <fs_line_b>.
    <fs_line_c>-value = <fs_line_c>-value + ( <fs_line_a>-value * <fs_line_b>-value ).
  ENDLOOP.
ENDLOOP.

GET RUN TIME FIELD lv_end_regular.
lv_difference = CONV decfloat34( ( lv_end_regular - lv_start_regular ) / 1000000 ).
WRITE: lv_difference, ' s for regular calculation.'.
