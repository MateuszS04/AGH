#include<iostream>
using namespace std;

int main(){
    char tab[]="Lubie narty";
    char *p=tab;

    for(size_t i=0;i<12;i++){
        cout<<*(p++);
    }
    cout<<endl;
    return 0;
}