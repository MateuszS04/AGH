#include<iostream>
using namespace std;

void clipping(double x){
    if(x>=10 && x<=20){
        cout<<x<<endl;
    }else if(x<10){
        cout<<"10"<<endl;
    }else {
        cout<<"20"<<endl;
    }
}
int main(){
    double x;
    cout<<"Wprowadź wartość: "<<endl;
    cin>>x;
    clipping(x);
}