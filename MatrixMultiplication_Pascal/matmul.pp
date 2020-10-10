program matmul;
uses 
  {$IFDEF UNIX}
  cthreads, cmem,
  {$ENDIF}
  MTProcs, DateUtils, sysutils;

const
    size = 1440;
type
    matrix = array[1..size] of array[1..size] of Single;
var
    a, b, c : matrix;
    fromTime, toTime: TDateTime;
procedure randomize(var x: matrix);
var
  i, j: Integer;
begin
  for i:=1 to size do
    for j:=1 to size do
      x[i][j] := Random;
end;
procedure printMatrix(var x: matrix);
var
  i, j: Integer;
begin
  for i:=1 to size do
    begin
      for j:=1 to size do
        write(x[i][j]);
      writeLn;
    end;
end;
procedure matmul(var x, y, o: matrix);
var
  i, j, k: Integer;
  sum: Single;
begin
  for i:=1 to size do
    for j:=1 to size do
    begin
      sum := 0;
      for k:=1 to size do
        sum += x[i][k] * y[k][j];
      o[i][j] := sum;
    end;
end;
procedure parMatmul(Index: PtrInt; Data: Pointer; Item: TMultiThreadProcItem);
var
  j, k: Integer;
  sum: Single;
begin
  for j:=1 to size do
  begin
    sum := 0;
    for k:=1 to size do
      sum += a[Index][k] * b[k][j];
    c[Index][j] := sum;
  end;
end;
begin
    randomize(a);
    randomize(b);
    
    fromTime := Now;
    
    matmul(a,b,c);
    
    toTime := Now;
    write('Single: ');
    write(MilliSecondsBetween(toTime, fromTime));
    write('ms');
    WriteLn;

    fromTime := Now;
    
    ProcThreadPool.DoParallel(@parMatmul, 1, size, nil);
    
    toTime := Now;
    write('Multi: ');
    write(MilliSecondsBetween(toTime, fromTime));
    write('ms');
    WriteLn;
end.