program main;

// Permet de représenter un entier positif de taille arbitraire 
// en base 2^32
// ex: si t est de type int_array et t := [5, 3] alors 
//     t représente l'entier 5 * (2^32)^0 + 3 * (2^32)^1 = 12884901893
type int_array = array of longword;

// Si le chiffre de poids fort est nul, alors il est retiré
// ex: t = [5, 3, 0] => Normalize(t) => t = [5, 3]
procedure Normalize (var t : int_array);
begin
    while t[length(t)-1] = 0 do 
        SetLength(t, length(t)-1);
end;

var t: int_array;
    c: longword;
begin
    t := int_array.create(5, 3, 0, 3, 4, 0, 0,0,0);
    for c in t do
        write(c, ' ');
    writeln();
    Normalize(t);
    for c in t do
        write(c, ' ');
    writeln();
end.