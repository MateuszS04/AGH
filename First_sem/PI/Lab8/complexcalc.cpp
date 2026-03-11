#include<iostream>
using namespace std;

class complexcalc{
    private:
    float *number_;
    public:
    complexcalc(){
        number_=new float[2];
        number_[0]=2;
        number_[1]=3;
    }
    ~complexcalc(){
        delete [] number_;
    }
    void setnumber(float r, float i){
        number_[0]=r;
        number_[1]=i;
    }
    bool isreal(){
        return (number_[1]==0);
    }
    bool isimag(){
        return (number_[0]!=0 && number_[1]!=0);
    }
    void print(){
        cout<<number_[0]<<"+"<<number_[1]<<"i\n";
        if(isreal()){
            cout<<"liczba jest rzeczywista\n";
        }else{
            cout<<"liczba nie jest rzeczywista\n";
        }
        if(isimag()){
            cout<<"liczba jest zespolona\n";
        }else{
            cout<<"liczba nie jest zespolona\n";
        }
    }

};

int main(){
    complexcalc p;
    float rpart, ipart;
    cout<<"podaj część rzeczywistą\n";
    cin>>rpart;
    cout<<"podaj część urojoną\n";
    cin>>ipart;
    p.setnumber(rpart, ipart);
    p.print();
   }