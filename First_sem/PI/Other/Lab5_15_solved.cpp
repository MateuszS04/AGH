#include<iostream>
using namespace std;
void write(int *tab, int size);

int main(){
    int *tab;
    int size;
    cout<<"podaj wielkość tablicy"<<endl;
    cin>>size;
    tab=new int [size];

    write(tab,size);
    for(int i=0; i<size; i++){
        cout<<*(tab+i);
    }
    delete [] tab;
}

void write(int *tab, int size){
    for(int i=0;i<size;i++){
        *(tab+i)=i;
    }
}