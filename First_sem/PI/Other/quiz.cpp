#include<iostream>
using namespace std;

float fun(float a){
    return a+a;
    a=5.0;
}

int main(){
    float a=2;
    fun(a);
}