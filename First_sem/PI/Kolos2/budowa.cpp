#include<iostream>
using namespace std;

struct car {
    float *displacement;
    float *seats;
};

int main(){
    car p;
    p.seats=new float;
    p.displacement=new float;
    *(p.seats)=3;
    *(p.displacement)=5;
    cout<<*(p.seats)<<endl;
    cout<<*(p.displacement)<<endl;
    delete p.displacement;
    delete p.seats;
}