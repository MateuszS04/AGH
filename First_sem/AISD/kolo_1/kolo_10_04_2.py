import random

class lotto:
    def __init__(self,numbers):
        self.numbers=sorted(numbers)
    
    def check(self,other):
        return sorted(self.numbers)==sorted(other.numbers)
    
    def graj(self,*args):
        trafienia=0
        for zestaw in args:
            if self.sprawdź(zestaw):
                trafienia+=1
            return trafienia
def losuj_zestaw():
    zestawy=[]
    for _ in range(0,1000):
        zestaw=set()
        while len(zestaw)<6:
            zestaw.add(random.randint(0,48))
        zestawy.append(lotto(zestaw))
    return zestawy

def policz_i_posortuj(zestawy):
    wystapienia={}
    for zestaw in zestawy:
        key=tuple(zestaw.numbers)
        wystapienia[key]=wystapienia.get(key,0)+1
    return sorted(wystapienia.items(), key=lambda x: x[1], reverse=True)

def zapisz_do_pliku(zestawy, nazwa_pliku):
    with open(nazwa_pliku, 'w') as f:
        for zestaw, ilosc in zestawy:
            f.write(f"{zestaw}:{ilosc}\n")

if __name__=='__main__':

 zestawy = losuj_zestaw()
 posortowane_zestawy=policz_i_posortuj(zestawy)

 nazwa_pliku=f"{posortowane_zestawy[0][0][0]}_{posortowane_zestawy[1][0][0]}.txt"
 zapisz_do_pliku(posortowane_zestawy, nazwa_pliku)
