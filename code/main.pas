program main;

uses utils;

var N:int_array;
  i:longword;
begin
  N:=int_array.create(51);
  for i:=0 to 2019 do
    prod(N, N, N);
  
end.

