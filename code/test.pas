type typetest = array of longint;
var tab: typetest;
    i: Integer;
begin
    tab := typetest.create(2, 2, 2);
    for i:=0 to 2 do
        writeln(tab[i]);
end.