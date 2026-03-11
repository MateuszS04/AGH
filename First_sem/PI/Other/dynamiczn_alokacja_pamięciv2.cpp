#include<iostream>
using namespace std;

class fib {
private:
    int* tab_;
    size_t size_;

public:
    fib(size_t size) {
        size_ = size;
        tab_ = new int[size_];
        tab_[0] = 0;
        tab_[1] = 1;
        for (size_t i = 2; i < size_; i++) {
            tab_[i] = tab_[i - 1] + tab_[i - 2];
        }
    }

    void print() {
        for (size_t i = 0; i < size_; i++) {
            cout << tab_[i];
            if (i < size_ - 1) {
                cout << ',';
            }
        }
        cout << endl;
    }

    ~fib() {
        delete[] tab_;
    }
};

int main() {
    fib p(5);
    p.print();

    return 0;
}
