#include<iostream>
using namespace std;

int main(){
    int tab1[]={1,2,3,4,5,6};
    int *start=tab1;
    int *end=&tab1[6];
    for(int i=0;i<6;i++){
        cout<<tab1[i]<<endl;
    }

    while(end>start){
        int x=*end;
        *end=*start;
        *start=x;
        end--;
        start++;
    }
cout<<endl;
    for(int i=1;i<=6;i++){
        cout<<tab1[i]<<endl;
    }
cout<<endl;
    char tab2[]={'a','b','c','d'};
    char *begin=tab2;
    char *finish=&tab2[4];
    for(int i=0;i<4;i++){
        cout<<tab2[i]<<endl;
    }
    while(finish>begin){
        char y=*finish;
        *finish=*begin;
        *begin=y;
        finish--;
        begin++;
    }
cout<<endl;
    for(int i=0;i<=4;i++){
        cout<<tab2[i]<<endl;
    }
    return 0;
    }
