#include<iostream>
using namespace std;

int main(){
    char tab[]={'a','b','c','d','e','f','g','h'};
    for(int i=0;i<8;i++){
        if(i%2!=0){
            cout<<tab[i]<<endl;
        }
    }
    return 0;
}