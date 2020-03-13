unit utils;

interface

/// Base utilisée pour stocker les entiers et faire les calculs
const BASE: QWord = 1 shl 32;

/// Permet de représenter un entier positif de taille.
/// arbitraire en base 2^32
/// ex: t = [5, 3] <=> t = 5 * (2^32)^0 + 3 * (2^32)^1 = 12884901893
type int_array = array of LongWord;

procedure write_digits(a: int_array);

procedure normalize (var t: int_array);
function smaller (a, b: int_array) : Boolean;

procedure sum(a, b: int_array; var s: int_array);
procedure diff (a, b: int_array; var s: int_array);
procedure prod (a, b : int_array; var p : int_array);

procedure div_by_digit (a : int_array; d : longword; var q : int_array; var r : longword);

implementation

/// Affiche l'écriture en base 2^32 du int_array,
/// avec le chiffre de poids faible à gauche
procedure write_digits(a: int_array);
var i:LongWord;
begin
  write ('[');
  for i:=0 to high (a) - 1 do
    write (a[i], ', ');
  writeln (a[high (a)], ']');
end;


/// Si le chiffre de poids fort est nul, alors il est retiré.
/// ex:
/// ```pascal
/// t := int_array.create (5, 3, 0, 0);
/// normalize(t);
/// writeln (t = int_array.create (5, 3));
/// ```
procedure normalize (var t : int_array);
begin
	// On doit vérifier que t <> nil en premier
	// car si t = nil, alors length (t) - 1 = -1
	// et on n'accède à de la mémoire non allouéew
    while (t <> nil) and (t[length(t) - 1] = 0)do
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
procedure sum (a, b: int_array; var s: int_array);
var i: LongWord;
	somme: QWord;
	retenue: LongWord;
begin
	Normalize (a); Normalize (b);

	if smaller (a, b) then
		sum (b, a, s)
	else 
	begin
		setLength (s, length (a) + 1);

		retenue := 0;
		for i:=0 to high (s) do
		begin
			// On utilise un QWord dans le cas où la somme est plus
			// grande que la base pour pouvoir calculer la retenue
			if i <= High (b) then
				somme := a[i] + retenue + b[i]
			else
				somme := a[i] + retenue;

			retenue := 0;
			if somme >= BASE then 
				retenue := somme div BASE;

			s[i] := somme mod BASE;
		end;
		Normalize (s);
	end;
end;

/// Réalise la soustraction de deux int_array
/// Note: ici on suppose a >= b;
procedure diff (a, b: int_array; var s: int_array);
var i: LongWord;
	difference, retenue: Int64;
begin
	Normalize (a); Normalize (b);
	
	setLength (s, length (a));

	retenue := 0;
	for i:=0 to High (s) do
	begin
		// On utilise un Int64 dans le cas où la différence
		// est négative pour pouvoir calculer la retenue
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

		s[i] := difference mod BASE;
	end;

	Normalize (s);
end;

// retenue_ld = retenue longue durée
procedure prod (a, b : int_array; var p : int_array);
var n, m: Longword;
	produit: QWord;
	retenue, retenue_ld, bs_atteinte: LongWord;
begin
	Normalize (a); Normalize (b);
	setLength (p, length (a) + length (b) + 1);

	// ça marche mais à refaire?
	// explication :
	// la somme n+m n'est pas croissante dans la boucle ci-dessous,
	// donc il faut conserver la retenue quand on retourne sur une
	// valeur inférieure de n+m, et l'ajouter quand atteint n+m+1
	// de plus, quand on atteint high(a)+high(b) il faut déplacer
	// la retenue à high(a)+high(b)+1
	retenue_ld := 0;
	bs_atteinte := 0;
	for n:=0 to high (a) do
	begin
		retenue := 0;
		for m:=0 to high (b) do
		begin
			produit := a[n]*b[m] + retenue;
			if (n + m = bs_atteinte + 1) then
				produit := produit + retenue_ld;
			retenue := produit div BASE;
			p[n+m] := (p[n+m] + produit) mod BASE;
			if m = high (b) then
			begin
			    retenue_ld := retenue;
				bs_atteinte := n + m; 
			end;
			if (n = high (a)) and (m = high (b)) then
				p[n+m+1] := retenue;
		end;
	end;

	Normalize (p);
end;

procedure div_by_digit (a : int_array; d : longword; var q : int_array; var r : longword);

var i, N : LongWord;

begin
	Normalize (a);
	setLength (q, length (a));
	r := 0;
	N := length (a) - 1;
	for i := N downto 0 do
		begin
			q[i] := (r * BASE + a[i]) div d;
			r := (r * BASE + a[i]) mod d;
		end;
	Normalize (q);
end;

end.

