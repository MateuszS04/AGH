#include<iostream> 
#include<cmath>
using namespace std;

double delta( double a, double b, double c){
    return b*b-4*a*c;
}

void quadraticfunction(double a, double b, double c){
    double z=delta(a,b,c);

    if(z>0){
        double x1=((-b-sqrt(z))/2*a);
        double x2=((-b+sqrt(z))/2*a);
        cout<<"x1="<<x1<<","<<"x2="<<x2<<endl;
    }else if(z==0){
        double x0=((-b)/2*a);
        cout<<"x0="<<x0<<endl;
    }else{
        cout<<"Brak miejsc zerowych"<<endl;
    }
}
int main(){
    double a,b,c;
    cout<<"Podaj współczynniki a,b,c :"<<endl;
    cin>>a;
    cin>>b;
    cin>>c;
    quadraticfunction(a,b,c);
    return 0;
}