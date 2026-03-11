#include<iostream>
using namespace std;

int main(){
    int x=2;
    int *y=&x;
    cout<<x<<endl;
    (*y)+=4;
    cout<<*y<<endl;
}