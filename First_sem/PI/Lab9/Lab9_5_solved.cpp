#include<iostream>
using namespace std;


class vector{
    public:
    double *data_;
    vector(double data){
        data_=new double;
        *data_=data;
    }
   // vector(const vector &copy){//konstruktor kopiujący
    //data_=new double;
    //memcpy(data_,copy.data_,sizeof(double));
    //}
    ~vector(){
        delete data_;
    }
    double add(vector *arg){// naprawa przez wskaźnik na argument
        return *data_+*(arg->data_);
    }
    double add(vector &arg){//naprawa prze referencję
        return *data_ + *(arg.data_);
    }
    //double add(vector arg){
        //return *data_+ *(arg.data_);
    //}
    void print(){
        cout<<data_<<"\n";//wypisanie adresów wskaźników
    }
};

int main(){
    vector a(1.0);
    vector b(0.3);
    cout<<a.add(&b)<<endl;//wskaźnik
    cout<<a.add(b)<<endl;//referencja
    a.print();
    b.print();
}