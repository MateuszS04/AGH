#include<iostream>
using namespace std;


    bool isreal(float rpart){
        return (rpart==0);
    }
    bool isimag(float rpart, float ipart){
        return (ipart!=0 && rpart!=0);
    }

class complexcalc{
    private:
    float *number_;
    float *sub_;
    public:
    complexcalc(){
        number_=new float [2];
        number_[0]=2;
        number_[1]=3;
        sub_=new float[4];
    }
    ~complexcalc(){
        delete [] number_;
        delete [] sub_;
    }
    bool equals(float rpart, float ipart){
        return (number_[0]!=rpart && number_[1]!=ipart);
    }
    void add(float rpart, float ipart){
        float r, i;
        sub_[0]= number_[0]+ rpart;
        sub_[1]= number_[1]+ ipart;
    }
    void substract(float rpart, float ipart){
        float a,b;
        sub_[2]=number_[0]-rpart;
        sub_[3]=number_[1]- ipart;
    }
    void print(){
        cout<<"Suma :"<<sub_[0]<<"+"<<sub_[1]<<"i\n";
        cout<<"różnica :"<<sub_[2]<<"+"<<sub_[3]<<"i\n";
    }
};
int main(){
    complexcalc p;
    float rpart, ipart;
    cout<<"podaj część rzeczywistą\n";
    cin>>rpart;
    cout<<"podaj część urojoną\n";
    cin>>ipart;
    isreal(rpart);
    isimag(rpart, ipart);
    if(isreal(rpart)){
        cout<<"Liczba jest rzeczywista\n";
    }else{
        cout<<"liczba jest nierzeczywista\n";
    }
    if(isimag(rpart,ipart)){
        cout<<"Liczba jest zespolona\n";
    }else{
        cout<<"liczba nie jest zespolona\n";
    }
    p.equals(rpart, ipart);
    if(p.equals(rpart, ipart)){
        cout<<"liczby nie są równe\n";
    }else{
        cout<<"liczby są równe\n";
    };
    p.add(rpart, ipart);
    p.substract(rpart, ipart);
    p.print();  
}