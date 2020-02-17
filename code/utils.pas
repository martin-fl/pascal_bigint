unit utils;

interface

/// Permet de représenter un entier positif de taille.
/// arbitraire en base 2^32
/// ex: t = [5, 3] <=> t = 5 * (2^32)^0 + 3 * (2^32)^1 = 12884901893
type int_array = array of longword;

procedure normalize (var t: int_array);
function smaller (a, b: int_array) : Boolean;

//procedure div_by_digit (a: int_array; d: longword; var q: int_array; var r: longword);

implementation

/// Si le chiffre de poids fort est nul, alors il est retiré.
/// ex:
/// ```pascal
/// t := int_array.create (5, 3, 0, 0);
/// normalize(t);
/// writeln (t = int_array.create (5, 3));
/// ```
procedure normalize (var t : int_array);
begin
    while t[length(t) - 1] = 0 do
        SetLength (t, length(t) - 1);
end;

/// Renvoie True lorsque a <= b.
/// Note: a et b ne sont pas nécessairement normalisés.
/// ex;
/// ```pascal
/// a := int_array.create (5, 3, 0, 3, 4, 1, 21, 0, 0);
/// b := int_array.create (3, 4, 1, 2, 4, 9, 0, 21);
/// writeln (smaller (a, b));
/// ```
function smaller (a, b: int_array) : Boolean;
var i: LongInt;
begin
	normalize (a); normalize (b);
	smaller := False;
	if (length (a) < length (b)) then
		smaller := True
	else if (length (a) = length (b)) then
		begin
			i := length (a) - 1;
			while (a[i]=b[i]) and (i>0) do
				i := i - 1;
			if (a[i]<=b[i]) then
				smaller := True
		end;
end;

end.
