#include <iostream>

using namespace std;

class Complex{
    private:
    int real_;
    int imag_;

    public:
    Complex(int real, int imag){
        real_=real;
        imag_=imag;
    }

    Complex(){};

    Complex operator+(const Complex &other){
        Complex result;
        result.real_ = this->real_ + other.real_;
        result.imag_ = this->imag_ + other.imag_;

        return result;
    }

    Complex GetComplex(){
        return {real_, imag_};
    }

    void print(){
        cout << real_ << endl;
        cout << imag_ << endl;
    }
};

int main(){

    Complex first(3,4);
    Complex second(5,8);

    Complex result = first + second;

    result.print();
}
