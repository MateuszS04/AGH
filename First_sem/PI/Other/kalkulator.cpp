#include<iostream>
using namespace std;

class calc{
    private:
    int *re_;
    int *im_;
    public:
    calc(){
        re_=new int;
        im_=new int;
    }
    void wczytaj(){
        int re,im;
        cout<<"Podaj część rzeczywistą"<<endl;
        cin>>re;
        cout<<"podaj część urojoną"<<endl;
        cin>>im;
        *re_=re;
        *im_=im;
    }
    void print(){
        cout<<*(re_)<<"+"<<*(im_)<<"i"<<endl;
    }
    bool isreal(){
        int re,im;
        re=*re_;
        im=*im_;
        if(re_!=0 && im==0){
            cout<<"Liczba jest rzeczywista"<<endl;
        return true;
        }else{
            cout<<"liczba nie jest rzeczywista"<<endl;
            return false;
        }
    }
    int getre()const{
        return *re_;
    }
    int getim()const{
        return *im_;
    }
    //friend bool equals(const calc &v1, const calc &v2);

    ~calc(){
        delete re_;
        delete im_;
    }

};
bool equals(calc &v1, calc &v2){
    //v2.wczytaj();
    //v2.print();
    if(v1.getre()==v2.getre()&&v1.getim()==v2.getim()){
        cout<<"equals"<<endl;
        return true;
    }else{
        cout<<"not equal"<<endl;
        return false;
    }
}
void add(calc &v1, calc &v2){
    int v3,v4;
    v3=v1.getre() + v2.getre();
    v4=v1.getim() + v2.getim();
    cout<<v3<<"+"<<v4<<"i"<<endl;
}

int main(){
    calc p1;
    p1.wczytaj();
    p1.print();
    p1.isreal();
    calc p2;
    p2.wczytaj();
    p2.print();
    equals(p1,p2);
    add(p1,p2);
}