#include<iostream> 
//#include<cstdlib>
class RandomNumberGenerator {
private:
double average; // Pole przechowujące średnią wartość
int count; // Licznik wylosowanych liczb

public:
RandomNumberGenerator() : average(0), count(0) {
srand(time(NULL)); // Inicjalizacja generatora liczb losowych
}

// Metoda generująca losową liczbę z przedziału 0-100
int my_random_number() {
int number = rand() % 101; // Losowanie liczby z przedziału 0-100
average = (average * count + number) / (count + 1); // Aktualizacja średniej wartości
count++; // Zwiększenie licznika
return number;
}

// Metoda zwracająca obliczoną średnią wartość
double getAverage() const {
return average;
}
};

int main() {
RandomNumberGenerator rng; // Tworzenie obiektu generatora liczb losowych

// Wywołanie metody my_random_number dwukrotnie
int number1 = rng.my_random_number();
int number2 = rng.my_random_number();

// Wyświetlenie wylosowanych wartości
std::cout << "Wylosowane liczby: " << number1 << ", " << number2 << std::endl;

// Wyświetlenie obliczonej średniej wartości
std::cout << "Średnia wartość: " << rng.getAverage() << std::endl;

return 0;
}