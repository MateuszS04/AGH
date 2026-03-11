#include<iostream>
using namespace std;

class Vector{
    public:
    double *data_;
    Vector(){
        data_=new double[2];      
    }
    ~Vector(){
        delete [] data_;
    }
    void setcoerdinates( double x, double y){
        data_[0]=x;
        data_[1]=y;
    }
        double *getcoordinates(){//wyciągnięcie współrzędnych zawartych w tablicy, dotęp do nich bez modyfikacji
        return data_;
    }
    Vector(const Vector &copy){
        data_=new double[2];
        memcpy(data_,copy.data_,sizeof(double));
    }
    double add(Vector arg){
        return *data_+*(arg.data_);
    }
    void write(){
        cout<<data_[0]<<endl;
        cout<<data_[1]<<endl;
        cout<<data_<<endl;
        cout<<*data_<<endl;
        cout<<&data_<<endl;
    }
};

int main(){
    Vector a;
    Vector b;
    a.setcoerdinates(1,2);
    b.setcoerdinates(3,3);
    a.write();
    a.add(b);
    cout<<a.add(b)<<endl;
}