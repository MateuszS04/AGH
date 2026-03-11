#include<iostream>
using namespace std;

int main(){
    int a=5;
    int b=8;
    int *x=&a;
    int *y=&b;
    cout<<x<<","<<y<<endl;
    cout<<*y-*x<<endl;
    cout<<*x+*y<<endl;
    cout<<a+*y<<endl;
    
    return 0;
}