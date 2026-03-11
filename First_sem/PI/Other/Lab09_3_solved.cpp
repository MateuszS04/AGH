#include<iostream>
using namespace std;

class Vec{
private:
    int *x_;
    int *y_;
public:
    Vec(int x,int y){
        x_=new int;
        y_=new int;
        *x_=x;
        *y_=y;
    }
    void print()const{
        cout<<*x_<<','<<*y_<<endl;
    }
    void add_one(){
        (*x_)++;
        (*y_)++;
    }
    int getX(){
        return *x_;
    }
    int getY(){
        return *y_;
    } 
    ~Vec(){
        delete x_;
        delete y_;
    }   
};
//void copyy(Vec v){ //kopiowabe są tylko wskaźniki na zmienną przez co pamięć nie jest właściwie zwalniana
  //  v.add_one();
  //  v.print();
//}
void refference(Vec &v){
    v.add_one();
    v.print();
};
void pointer(Vec *v){
    v->add_one();
    v->print();
};
void stała_referencyjna(const Vec &v){//stała referencyjna nie pozwala zmieniać zmiennych zawartych w klasie 
    v.print();
    //v.add_one();
    //v.print();
};

// zadanie numer 2
void copyyv2(Vec x[], int y){
    for(int i=0; i<y; i++){
        x[i].add_one();
        x[i].print();
    }
};

int main(){
    Vec p1(1,2);
    copyy(p1);

    Vec p2(3,4);
    pointer(&p2);

    Vec p3(5,6);
    refference(p3);

    Vec p4(7,8);
    stała_referencyjna(p4);
}