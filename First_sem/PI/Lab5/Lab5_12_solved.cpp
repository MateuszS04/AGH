#include<iostream>
using namespace std;

struct Ski{
    int length;
    float radius;
};
int main(){
    int tab[]={1,2,3,4,5,6,7,8,9,10};
    int*x=tab;
    for(size_t i=0;i<10;++i){
        cout<<*x<<", ";
        cout<<x<<endl;
       (*x)++;
    }
    cout<<endl;
    char tab2[]={'a','b','c','d'};
    char *y=tab2;
    for(size_t i=0;i<4;i++){
        cout<<*y<<", "<<x<<endl;
        (*y)++;
    }
    Ski Sl={1, 1.5};
    Ski *z=&Sl;
    Sl.length=1;
    Sl.radius=2;
    z->length=168;
    z->radius=12.5;
    cout<<Sl.length<<endl;
    cout<<Sl.radius<<endl;
    return 0;
}