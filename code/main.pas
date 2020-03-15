program main;

uses utils;

function estDivisiblePar17(a: int_array): Boolean;
var i:longword;
    somme:qword;
begin
  somme := 0;
  for i:=0 to high(a) do
    somme := somme + a[i];
  estDivisiblePar17 := (somme mod 17) = 0;
end;

var N1, N2:int_array;
    i:Longword;
begin

  // Calcul de 51^2020
  N1 := int_array.create(51);
  N2 := int_array.create(51);
  for i:=2 to 2020 do
    prod(N1, N2, N1);
  write_int_array(N1);

  // Doit affichier "TRUE"
  writeln(estDivisiblePar17(N1));
end.

