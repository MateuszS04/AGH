#include<iostream>
using namespace std;

int main(){
    long int size=1000000;
    int*p=(int *)malloc(size*sizeof(int));

    for(int i=0;i<size;++i){
        p[i];
    }
    free(p);
}