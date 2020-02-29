program main;

uses utils;

var a, b, add, sub, mul, mul_d: int_array;
    i: shortint;
begin
  a := int_array.create (1 shl 31 + 4, 4, 0, 0, 3 + 1 shl 20);
  b := int_array.create (1 shl 30, 9, 2 + 1 shl 25, 0);
  
  //a := int_array.create (50, 20);
  //b := int_array.create (25, 11);

  prod (a, b, mul);
  write_digits(mul)
end.

