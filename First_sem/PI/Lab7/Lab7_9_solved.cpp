#include<iostream> 
#include<cmath>
using namespace std;

struct coefficient{
    double a;
    double b;
    double c;
};
double delta(const coefficient& y){
    return y.b*y.b-4*y.a*y.c;
}

 void quadraticfunction(const coefficient& y){
    double z=delta(y);

    if(z>0){
        double x1=((-y.b-sqrt(z))/2*y.a);
        double x2=((-y.a+sqrt(z))/2*y.a);
        cout<<"x1="<<x1<<","<<"x2="<<x2<<endl;
    }else if(z==0){
        double x0=((-y.b)/2*y.a);
        cout<<"x0="<<x0<<endl;
    }else{
        cout<<"Brak miejsc zerowych"<<endl;
    }
 }
 int main(){
    coefficient y;
    cout<<"Podaj współczynniki a,b,c :"<<endl;
    cin>>y.a;
    cin>>y.b;
    cin>>y.c;
    quadraticfunction(y);
    return 0;
 }