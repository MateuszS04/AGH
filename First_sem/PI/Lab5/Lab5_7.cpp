#include<iostream>
using namespace std;

int main(){
    char tab[2]={3,7};

    cout<<(void*)&tab[0]<<endl;//adres przechowywania zmiennej 3
    cout<<(void*)&tab[1]<<endl;//adres przechowywania zmiennej 7
    return 0;
}