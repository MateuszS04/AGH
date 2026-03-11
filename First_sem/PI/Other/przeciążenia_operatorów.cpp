#include<iostream>
using namespace std;

class complex{
    public:
    float re_,im_;
    complex(float,float);

    complex operator +(const complex &right){
    complex result;
    result.re_=this->re_+right.re_;
    result.im_=this->im_+right.im_;
    return result;

};
};
complex::complex(float re, float im):re_(re),im_(im){}; 

int main(){
    complex c1(1,3);
    complex c2(3,-7);

    complex c=c1 + c2;
    complex d=c1.operator+(c2);
    cout<<c.re_<<","<<c.im_<<endl;
}