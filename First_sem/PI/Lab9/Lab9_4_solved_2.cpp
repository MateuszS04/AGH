#include<iostream>
using namespace std;

class vector{
    public:
    double *data_;
    vector(double data){
        data_=new double;
        *data_=data;
    }
    double add(vector &arg){
        return *data_+*(arg.data_);
    }
    void print(){
        cout<<data_<<endl;;
    }
    ~vector(){
        delete data_;
    }
};

int main(){
    vector a(1.0);
    vector b(0.3);
    cout<<a.add(b)<<endl;
    a.print();
    b.print();
}