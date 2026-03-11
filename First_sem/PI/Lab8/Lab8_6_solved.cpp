#include<iostream>
using namespace std;

class vector2d{
    private:
    int *tab_;
        public:
    vector2d(){
    tab_=new int[2];
    }
    ~vector2d(){
        delete []tab_;
    }
    void setx1x2(int a, int b){
        tab_[0]=a;
        tab_[1]=b;
    };
    void getprint2d(){
        cout<<tab_[0]<<","<<tab_[1]<<endl;
    };
    void getadd(int a,int b){
        int x3=a;
        int x4=b;
        cout<<tab_[0]+x3<<","<<tab_[1]+x4<<endl;
    };
};

int main(){
    vector2d p;
    p.setx1x2(4,6);
    p.getprint2d();
    p.getadd(5,6);
} 