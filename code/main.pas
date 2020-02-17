program main;

uses utils;

var a, b: int_array;
begin
  a := int_array.create (5, 3, 12, 3, 4, 1, 21, 0);
  b := int_array.create (5, 3, 1, 3, 4, 1, 21, 0);
  writeln (smaller (a, b));
end.
