import random
from collections import Counter

class Lotto:
    def __init__(self, numbers):
        self.numbers = numbers

    def sprawdź(self, other):
        return Counter(self.numbers) == Counter(other.numbers)

def graj():
    ilość = int(input("Podaj ilość zestawów liczb (max 1000): "))
    zestawy = []
    for _ in range(ilość):
        zestaw = []
        for _ in range(6):
            zestaw.append(random.randint(0, 48))
        zestawy.append(zestaw)
    return zestawy

def zapisz_do_pliku(zestawy, nazwa_pliku):
    with open(nazwa_pliku, 'w') as file:
        for zestaw in zestawy:
            file.write(','.join(map(str, zestaw)) + '\n')

def main():
    zestawy = graj()
    liczności = Counter(tuple(zestaw) for zestaw in zestawy)
    posortowane = sorted(liczności.items(), key=lambda x: x[1], reverse=True)
    for zestaw, liczność in posortowane[:1000]:
        nazwa_pliku = '_'.join(map(str, zestaw[:2])) + '.txt'
        zapisz_do_pliku([zestaw], nazwa_pliku)

if __name__ == "__main__":
    main()
