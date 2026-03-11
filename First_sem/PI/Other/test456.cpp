#include<iostream>
#include<cstring>
using namespace std;

class fib {
protected:
    size_t size_;
    int* tab_;

public:
    fib(size_t size) : size_(size), tab_(nullptr) {
        if (size_ < 2) {
            cout << "za mały rozmiar" << endl;
        } else {
            tab_ = new int[size_];
            tab_[0] = 1;
            tab_[1] = 1;
            for (size_t i = 2; i < size_; i++) {
                tab_[i] = tab_[i - 1] + tab_[i - 2];
            }
        }
    }

    void add() {
        int* tab2 = new int[size_ + 1];
        memcpy(tab2, tab_, size_ * sizeof(int));
        delete[] tab_;
        tab2[size_] = tab2[size_ - 1] + tab2[size_ - 2];
        tab_ = tab2;
        size_++;
    }

    void print() {
        for (size_t i = 0; i < size_; i++) {
            cout << tab_[i] << ',';
        }
        cout << endl;
    }

    ~fib() {
        delete[] tab_;
    }
};

class fib_start : public fib {
private:
    int a_;
    int b_;

public:
    fib_start(size_t size, int a, int b)
        : fib(size), a_(a), b_(b) {
        if (size_ >= 2) {
            tab_[0] = a_;
            tab_[1] = b_;
            for (size_t i = 2; i < size_; i++) {
                tab_[i] = tab_[i - 1] + tab_[i - 2];
            }
        }
    }

    void remove() {
        if (size_ < 2) {
            cout << "za krótki ciąg" << endl;
            return;
        }
        for (size_t i = 1; i < size_; i++) {
            tab_[i - 1] = tab_[i];
        }
        --size_;
    }

    ~fib_start() {
    }
};

int main() {
    fib p(1);
    p.add();
    p.print();

    fib_start q(1, 3, -5);
    q.print();
    q.remove();
    q.print();

    return 0;
}
