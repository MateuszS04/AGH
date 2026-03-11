#include <iostream>
using namespace std;

class rook : public plansza {
public:
    rook()
        : plansza() {
    }

    bool check() {
        // Warunek na sprawdzenie czy na polu jest wieża
        return (board[k][w] == 'w');
    }

    bool check_the_way(int k1, int w1) {
        // Sprawdzenie czy podana komórka jest inna od startowej
        if (k == k1 && w == w1) {
            return false; // Ruch do tego samego miejsca
        }

        // Wykrywanie kolizji
        if (k == k1) { // Kolizje poziome
            if (w < w1) {
                for (int i = w + 1; i <= w1; i++) { // Ruch w prawo
                    if (board[k][i] != ' ') {
                        return false;
                    }
                }
            } else {
                for (int i = w - 1; i >= w1; --i) { // Ruch w lewo
                    if (board[k][i] != ' ') {
                        return false;
                    }
                }
            }
        } else if (w == w1) { // Kolizje pionowe
            if (k < k1) {
                for (int i = k + 1; i <= k1; i++) { // Ruch w dół
                    if (board[i][w] != ' ') {
                        return false;
                    }
                }
            } else {
                for (int i = k - 1; i >= k1; --i) { // Ruch w górę
                    if (board[i][w] != ' ') {
                        return false;
                    }
                }
            }
        } else {
            return false; // Ani pionowy, ani poziomy
        }
        return true; // Wszystko jest git
    }
};
