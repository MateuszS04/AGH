#include<iostream>
using namespace std;

int main() {
    char tab[] = "PrzykladowyTekst";
    char *ptr = tab;

    // Wyświetl co drugi znak
    cout << "Co drugi znak:" << endl;
    while (*ptr != '\0') {
        cout << *ptr;
        ptr += 2;
    }
    cout << endl;

    // Przywróć wskaźnik na początek tablicy
    ptr = tab;

    int n = 3; // Przykładowa wartość n
    int i = 1;

    // Wyświetl pierwszy, drugi, czwarty, siódzy itd. znak (poprzedni + n)
    cout << "Pierwszy, drugi, czwarty, siódzy itd. znak:" << endl;
    while (*(ptr + n * (i - 1)) != '\0') {
        cout << *(ptr + n * (i - 1));
        i++;
    }
    cout << endl;

    return 0;
}