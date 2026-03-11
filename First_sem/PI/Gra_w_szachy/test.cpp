#include<iostream>
using namespace std;

class board {
private:
    bool player_;
    int a_;
protected:
    char* tab_;

public:
    board() {
        tab_ = new char[9];
        for (int i = 0; i < 9; i++) {
            tab_[i] = ' ';
        }
    }

    void select_player() {
        int p;
        cout << "Podaj gracza (0 dla X, 1 dla O): ";
        cin >> p;
        player_ = (p == 0);
    }

    void board1() {
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                cout << "[" << tab_[i * 3 + j] << "]";
            }
            cout << endl;
        }
    }

    void wczytaj_pole() {
        cout << "Podaj pole na którym chcesz postawić znak (0-8): ";
        do {
            cin >> a_;
            if (a_ >= 0 && a_ < 9 && tab_[a_] == ' ') {
                tab_[a_] = (player_ ? 'X' : 'O');
                break;  // Break out of the loop if the move is valid
            } else {
                cout << "Błąd, podaj inne pole: ";
            }
        } while (true);
    }
};

int main() {
    board a;
    a.board1();
    a.select_player();
    a.wczytaj_pole();
    a.board1();

    return 0;
}

