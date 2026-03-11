#include<iostream>
using namespace std;

class p{
    public:
    char tab[12]={"Ala ma kota"};
    int pozycja;
    void setpozycja(){
    cout<<"podaj pozycję"<<endl;
    cin>>pozycja;
    }
    void myprint(){
        if(pozycja>=0&&pozycja<=11){
        cout<<tab[pozycja]<<endl;
        }else{
            cout<<"pozycja poza zakresem"<<endl;
        }
    }
    void my_move(){
        if(pozycja>=0&&pozycja<10){
            pozycja+=1;
        }else if(pozycja==11){
            pozycja-=11;
        } else if(pozycja==10){
            pozycja-=10;
        }
    }
};
int main(){
    p q;
    q.setpozycja();
    q.myprint();
    q.my_move();
    q.myprint();
}