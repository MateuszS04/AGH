% fi(value,sign,noBitsAll,noBitsFract)
% value-liczba do zakodowania
% sign- 0=bez znaku w kodzie U2, 1 = z znakiem w kodzie U2
% noBitsAll- liczba wszystkich uzytych bituw
% noBitsFract-liczbabitow czesc ulamkowej
a=fi( 141,0,8,0), a.bin,
b=fi( 115,0,8,0), b.bin,
c=fi( 115,1,8,0), c.bin,
d=fi(-115,1,8,0), d.bin,

e=fi(11,0,8,0), e.bin,
f=fi(11,1,8,0), f.bin,
g=fi(11,0,16,0), g.bin,
h=fi(11,1,16,0), g.bin,
