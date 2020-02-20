unit utils;

interface

/// Base utilisée pour stocker les entiers et faire les calculs
const BASE: QWord = 1 shl 32;

/// Permet de représenter un entier positif de taille.
/// arbitraire en base 2^32
/// ex: t = [5, 3] <=> t = 5 * (2^32)^0 + 3 * (2^32)^1 = 12884901893
type int_array = array of LongWord;

procedure normalize (var t: int_array);
function smaller (a, b: int_array) : Boolean;

procedure sum(a, b: int_array; var s: int_array);
procedure diff (a, b: int_array; var s: int_array);

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
var i: LongWord;
begin
	normalize (a); normalize (b);
	smaller := False;
	if (length (a) < length (b)) then
		smaller := True
	else if (length (a) = length (b)) then
	begin
		i := length (a) - 1;
		// On compare jusqu'à trouver des chiffres différents
		while (a[i]=b[i]) and (i>0) do
			i := i - 1;
		// On compare les chiffres différents et on conclut
		if (a[i]<=b[i]) then
			smaller := True
	end;
end;

/// Réalise la somme de deux int_array
procedure sum(a, b: int_array; var s: int_array);
var i: LongWord;
	somme: QWord;
	retenue: LongWord;
	max, min: int_array;
begin
	Normalize (a); Normalize (b);
	if smaller(a, b) then
	begin
		min := a;
		max := b;
	end
	else
	begin
		min := b;
		max := a;
	end;

	// On a length (s) = max (length (a), length (b)) + 1
	setLength (s, length(max) + 1);
	s := copy (max, 0, length (max));

	retenue := 0;

	// On stocke temporairement le résultat de la somme
	// dans un QWord en cas de dépassement, pour pouvoir
	// calculer la retenue dans tous les cas et la propager.
	for i:=0 to high (min) do
	begin
		somme := s[i] + min[i] + retenue;				
		retenue := somme div BASE;
		// Note: ici l'expression est équivalente à s[i] := somme mod BASE.
		s[i] := somme;
	end;

	Normalize (s);
end;

/// Réalise la soustraction de deux int_array
/// Note: ici on impose a >= b;
procedure diff (a, b: int_array; var s: int_array);
var i: LongWord;
	difference: Int64;
	retenue: Int64;
begin
	assert (not (smaller (a, b)));
	Normalize (a); Normalize (b);
	
	setLength (s, length (a));

	retenue := 0;
	for i:=0 to High (s) do
	begin
		// On utilise un Int64 dans le cas où la différence est négative
		// pour pouvoir calculer la retenue
		if i <= High (b) then
			difference := a[i] + retenue - b[i]
		else
			difference := a[i] + retenue;

		retenue := 0;
		// En Pascal, le reste peut être négatif.
		// Si on ne veut pas qu'il le soit, il faut lui ajouter
		// la base et retirer 1 au quotient.
		if difference < 0 then 
			retenue := (difference div BASE) - 1;
		// Note: ici l'expression est équivalente à s[i] := difference mod BASE.
		s[i] := difference;
	end;

	Normalize (s)
end;



end.

