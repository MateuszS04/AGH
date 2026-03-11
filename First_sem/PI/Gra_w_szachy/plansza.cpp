#include <iostream>
#include <random>
using namespace std;

class plansza {
private:
    bool kolor = true;
    int gracz=1;
    int k, w;
    char przesun;
public:
    char board[8][8];
    plansza() {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                board[i][j] = ' ';
            }
        }
    }
    void drukujPlansze() {
        if (kolor == true) {
            gracz = 1;
        }
        else {
            gracz = 2;
        } 
        kolor = !kolor;
        cout << "Aktualna plansza" << endl;
        cout << "Tura gracza nr "<<gracz << endl;
        for (int i=0; i < 8; i++) {
            cout << " +---+---+---+---+---+---+---+---+"<<endl;
            cout << 8 - i << "|";
            for (int j=0; j < 8; j++) {
                cout << " " << board[i][j] << " |";
            }
            cout<<endl;
        }
        cout << " +---+---+---+---+---+---+---+---+" << endl;
        cout << "   A   B   C   D   E   F   G   H" << endl;
        cout << endl;
    }
    void random_start() {
        char figury[] = { 'p', 'P', 'g', 'G', 'h', 'H', 'w', 'W', 'q', 'Q', 'k', 'K' };
        for (int i = 0; i < (sizeof(figury) / sizeof(figury[0])); i++) {
            random_device rd;
            uniform_int_distribution<int> distribution(0, 7);
            int wiersz = distribution(rd);
            int kolumna = distribution(rd);
            while (board[wiersz][kolumna] != ' ') {
                wiersz = distribution(rd);
                kolumna = distribution(rd);
            }

            board[wiersz][kolumna] = figury[i];
        }
    }
    void wczytaj_pole() {//nie wiem dlaczego nie dziala ale w sumie tutaj i tak bedziecie musieli cos kminic z figurami ale postaram sie jeszcze naprawic chyba ze ktos swierzym okiem zobaczy
//Update 1: Problem opisany wyzej naprawiony        
        char a, b, przesun;
        int k, w, x, y;
        do {
            cout << "Podaj wspolrzedne pola: ";
            cin >> a >> b;
            k = b - '1';
            w = a - 'A';
            k=k-7;
            k=k*(-1);
            if (!(k >= 0 && k <= 7 && w >= 0 && w <= 7 && board[k][w] != ' ')) {
                cout << "Nieprawidlowe pole lub pole jest puste. Sprobuj jeszcze raz." << endl;
            }
        } while (!(k >= 0 && k <= 7 && w >= 0 && w <= 7 && board[k][w] != ' '));
        przesun = board[k][w];
        board[k][w] = ' ';
        do {
            cout << "Podaj wspolrzedne pola docelowego: ";
            cin >> a >> b;

            w = a - 'A';
            k = b - '1';
            k=(k-7)*(-1);
            if (!(k >= 0 && k <= 7 && w>=0 && w<=7)) {
                cout << "Nieprawidlowe pole. Sprobuj jeszcze raz." << endl;
            }
            else {
                board[k][w] = przesun;
            }
         } while (!(k >= 0 && k <= 7 && w>=0 && w<=7));
    }

};


int main() {
    plansza a;
    a.drukujPlansze();//pierwsza plansza jest tyko testoowa dlatego gra sie rozpoczyna od gr nr 2, uzywac duzych liter przy podawaniu pola
    a.random_start();
    a.drukujPlansze();
    a.wczytaj_pole();
    a.drukujPlansze();
}
