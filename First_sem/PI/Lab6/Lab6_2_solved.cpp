#include<iostream>
using namespace std;

int main(){
    char tab[]="costamprzyklad";
    char *x;
    x=tab;
    while(*x!='\0'){
        cout<<*x;
        x+=2;
    }
    cout<<endl;
    x=tab;
    int n=3;
    int i=1;
    while (*(x + n * (i - 1)) != '\0') {
        cout << *(x + n * (i - 1));
        i++;
    }
    cout << endl;
}