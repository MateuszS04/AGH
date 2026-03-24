#napisz klase której obiekt bedzie inicjalizowany listą 500 
#losowych liczb całkowitych z przedziału <0,100>. Klasa powinna zawierać:
#1. metode MINIMALNY zwracajacy najmniejszy element
#2. metode MAKSYMALNY zwrajajacy najwiekszy element
#3. metode SUMUJE zwracajaca sume elementow obiektu
#4. metode ODCHYL zwracajaca wartosc odchylenia standardowego wartosci
#5. metode MSU zwracajaca wartosc mody obiektu
#6. metode MDU zwracajaca mediane
#7. metode ZAPISUJE, które otworzy plik o nazwie takiej jak pierwszy element listy, 
#zapisze elementy listy oraz wszystkie wartosci bedace rezultatem wykonania metod klasy, po czym zamknie plik

import random
import math

class numbers:

    def __init__(self):
        self.num=[]
    
    def ran_num(self):
        for i in range(0,500):
            self.num.append(random.randint(0,100))

    def minimum(self):
        self.num.sort()
        print(self.num)
        print(self.num[0])
    
    def maximum(self):
        print(self.num[499])
    
    def suma(self):
        print(sum(self.num))
    
    def odchyl(self):
        mean=sum(self.num)/len(self.num)
        variance=sum((x-mean)**2 for x in self.num)/len(self.num)
        print(math.sqrt(variance))
    
    def mode(self):
        print(max(set(self.num), key=self.num.count))
    
    def mdu(self):
        sorted_num=sorted(self.num)
        n=len(sorted_num)
        if n%2==0:
            median=((sorted_num[(n//2) -1])+sorted_num[(n//2)])/2
            print(median)
        else:
            median=sorted_num=sorted_num[n/2]
            print(median)
    
    def zapisuje(self):
        filename=str(self.num[0])+ '.txt'
        with open(filename,'w') as file:
            file.write('List elements:\n')
            for element in self.num:
                file.write(str(element)+'\n')
            file.write('\nResults:\n')
            file.write("Standard deviation: {}\n".format(self.odchyl()))
            file.write("Mode:{}\n".format(self.mode()))
            file.write('Median:{}\n'.format(self.mdu()))


x=numbers()
x.ran_num()
x.minimum()
x.maximum()
x.suma()
x.odchyl()
x.mode()
x.mdu()
x.zapisuje()
