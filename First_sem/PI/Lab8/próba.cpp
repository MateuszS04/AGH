#include<iostream>
using namespace std;

struct car {
    float displacement;
    float *seats;
};

int main(){
    car p;
    p.seats=new float;
    *(p.seats)=2;
    cout<<*(p.seats)<<endl;
    delete p.seats;
}