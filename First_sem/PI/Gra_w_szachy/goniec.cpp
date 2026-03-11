#include<iostream>
using namespace std;// chyba jest okej ale w poniedziałek wieczorem jeszcze to przejżę bo dziś to już nie mam siły
//generalnie koncepcja ta sama co przy wieży tylko z innymi możliwościami poruszania się 

class bishop:public plansza{
public:
bishop()
:plansza(){
}
bool check(){
    return(board[k][w]=='g')
}
bool check_the_way(int k, int k1, int w, int w1){// tak samo jak w wieży k1, w1 to współrzędne docelowe, a k i w to współrzędne startowe
    if(k==k1&&w==w1){// żeby znalazł inne pole
        return false;
    }
    if(!((k!=k1&&w==w1)||(k==k1&&w!=w1))){//żeby nie mógł chodzić tak jak królowa
        return false;
    }
    if(k<k1 && w<w1){//ruch po skosie w prawo do góry
        for(int i=k+1, j=w+1; i<=k1 && j<=w1; i++, j++){
            if(board[i][j]!=' '){
                return false;
            }
        }
    }else if(k>k1 && w<w1){//po skosie(jak to goniec XD) w lewo do góry
         for(int i=k-1, j=w+1; i<=k1 && j<=w1; i--, j++){
            if(board[i][j]!=' '){
                return false;
            }
         }
    }else if(k>k1 && w<w1){// ruch po skosie w lewo w dół
        for(int i=k-1, j=w-1; i<=k1 && j<=w1; i--, j--){
            if(board[i][j]!=' '){
                return false;
            }
        }
    }else if(k<k1&& w>w1){// ruch po skosie w prawo w dół
        for(int i=k+1, j=w+1; i<=k1, j<=w1; i++, j--){
            if(board[i][j]!=' '){
                return false;
            }
        }
    }
    return true;
}
};