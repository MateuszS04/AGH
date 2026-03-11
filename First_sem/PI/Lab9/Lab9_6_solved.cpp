#include<iostream>
#include<cstring>
using namespace std;

class vector{
    private:
    double *data_;
    size_t size_;
    public:
    vector(size_t size, double value){
        size_=size;
        data_=new double[size];
        for(size_t i=0; i<size;++i){
            data_[i]=value;
        }        
    }
    vector(const vector &copy){
        size_=copy.size_;
        data_=new double[size_];
        memcpy(data_,copy.data_,size_ *sizeof(double));
    }
    ~vector(){
        delete [] data_;
    }
    double add(vector arg){
        return data_[0]+arg.data_[0];
    }
    void print(){
        for(size_t i=0;i<size_;++i){
            cout<<data_[i]<<' ';
        }
        cout<<'\n';
    }
};

int main(){
    vector a(2,1.0);
    vector b(3,0.3);
    cout<<a.add(b)<<endl;
    a.print();
    b.print();
}