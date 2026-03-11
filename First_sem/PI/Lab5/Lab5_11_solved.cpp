#include<iostream>
using namespace std;

int main(){
    int *x;
    int y=2;
    if(y<5){
        int z=2*y;
        x=&z;
    }
    cout<<x<<endl;
    }