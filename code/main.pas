program main;

// Permet de représenter un entier positif de taille.
// arbitraire en base 2^32
// ex: t = [5, 3] <=> t = 5 * (2^32)^0 + 3 * (2^32)^1 = 12884901893
type int_array = array of longword;

// Si le chiffre de poids fort est nul, alors il est retiré.
// ex: t = [5, 3, 0, 0] => Normalize(t) => t = [5, 3]
procedure Normalize (var t : int_array);
begin
    while t[length(t) - 1] = 0 do 
        SetLength (t, length(t) - 1);
end;

// Renvoie True lorsque a <= b.
// Note: a et b ne sont pas nécessairement normalisés.
function smaller (a, b: int_array):boolean;
begin
	Normalize (a); Normalize (b);
	smaller := False;
	if length (a) < length (b) then
		smaller := True
	else if (length (a) = length (b)) and (a[length(a)-1] <= b[length(a)-1]) then
		smaller := True;
end;

var a, b: int_array;
    //c: longword;
begin
    a := int_array.create (5, 3, 0, 3, 4, 1, 21, 0, 0);
    b := int_array.create (3, 4, 1, 2, 4, 9, 0, 21);
	writeln (smaller (a, b));
end.
