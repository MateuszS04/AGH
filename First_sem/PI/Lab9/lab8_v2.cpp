#include<iostream>
using namespace std;

class vector2d{
    private:
    float *tab_;
    public:
    vector2d(){
        tab_=new float[2];
        tab_[0]=2;
        tab_[1]=3;
    }
    ~vector2d(){
        delete [] tab_;
    }
    void setx1x2(float x1, float x2){
        tab_[0]=x1;
        tab_[1]=x2;
    }
    void add(vector2d *vec){
        tab_[0]+=vec->tab_[0];
        tab_[1]+=vec->tab_[1];
    }
    void print(){
        cout<<tab_[0]<<','<<tab_[1]<<'\n';
    }
};

int main(){
    vector2d p;
    p.setx1x2(2,4);
    p.print();
}