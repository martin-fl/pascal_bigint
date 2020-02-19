program main;

uses utils;

var a, b, s: int_array;
    i: shortint;
begin
  a := int_array.create (1 shl 31 + 4, 4, 0, 0, 3 + 1 shl 20);
  b := int_array.create (1 shl 30, 9, 2, 0);
  
  sum (a, b, s);
  for i:=0 to high (s) do
    write (s[i], ' ');
  writeln;

  diff (a, b, s);
  for i:=0 to high (s) do
    write (s[i], ' ');
  writeln;
end.
