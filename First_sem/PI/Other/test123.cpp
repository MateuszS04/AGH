#include<iostream>
using namespace std;

struct car{
    double *displacemant;
    double *seats;
};

int main(){
    car b;
    b.displacemant=new double;
    b.seats=new double;
    *b.seats=2;
    *b.displacemant=4;

    cout<<*b.seats<<','<<*b.displacemant<<endl;
    delete b.displacemant;
    delete b.seats;
}