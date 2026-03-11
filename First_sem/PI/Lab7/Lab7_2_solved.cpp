#include<iostream>
using namespace std;

int main(){
    int size;
    int *tab=new int[size];
    cout<<"Podaj rozmiar tablicy :"<<endl;
    cin>>size;

    for(size_t i=0;i<size; i++){
        tab[i]=i;
        cout<<tab[i];
    }
    delete [] tab;
}