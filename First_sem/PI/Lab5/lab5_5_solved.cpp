#include<iostream>
using namespace std;

struct car{
    int seats;
    float range;
};
int main(){
    car tab[10];
    car *x;
    int seats;
    tab[0].seats=5;
    x=&tab[0];
    tab[0].range=500;
    car au={30, 1500};
    tab[2]=au;
    size_t sizeoftab=sizeof(tab)/sizeof(int);
    cout<<"rozmiar tablicy"<<sizeoftab<<endl;

    return 0;
}