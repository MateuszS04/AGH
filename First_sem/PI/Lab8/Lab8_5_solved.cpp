#include<iostream>
using namespace std;

class vector2d{
    private:
    int x1_;
    int x2_;
    public:
    vector2d(){
        x1_=0;
        x2_=0;
    };
    void setx1x2(int a, int b){
        x1_=a;
        x2_=b;
    };
    void getprint2d(){
        cout<<x1_<<","<<x2_<<endl;
    };
    void getadd(int a,int b){
        int x3=a;
        int x4=b;
        cout<<x1_+x3<<","<<x2_+x4<<endl;
    };
};

int main(){
    vector2d p;
    p.setx1x2(3,4);
    p.getprint2d();
    p.getadd(5,6);
} 