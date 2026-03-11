#include<iostream>
using namespace std;

class rook:public plansza{
    private:
    public:
    rook()
    :plansza(){
    }
    wczytaj_pole();
    bool check(){//warunek na sprawdznie czy na polu jest wieża
    return (board[k][w]=='w');
    }
    bool check_the_way(int k, int w, int k1, int w1){//k-kolumna startowa k1-kolumna docelowa tak samo z wierszami

        if(k==k1 && w==w1)//sprawdzenie czy podana komórka jest inna od startowej
        return false;// ruch do tego samego miejsca
        //wykrywanie kolizji
            if(w==w1){//kolizje poziome
                if(k<k1){
                    for(int i=k+1; i<=k1; i++){//ruch w prawo
                        if(board[k][i]!=' '){
                        return false;
                        }else{
                            continue;
                        }
                    }
                }else{
                    for(int i=k-1;i>=k1;--i){//ruch w lewo
                        if(board[k][i]!=' '){
                        return false;
                        }else{
                            continue;
                        }
                    }
                }
            }else if(k==k1){  //kolizje pionowe
            if(w<w1){//ruch w dół
                for(int i=w+1; i<=w1; i++){
                    if(board[i][k]!='0'){
                        return false;
                    }else{
                        continue;
                    }
                }
            }else{//ruch w górę
                for(int i=w-1;i<=w1;--i){
                    if(board[i][k]!=' '){
                        return false;
                    }else{
                        continue;
                    }
                }
            }        
            }else {
            return false;//ani pionowy, poziomy
        }
        return true;//wszystko jest git
    }
};
