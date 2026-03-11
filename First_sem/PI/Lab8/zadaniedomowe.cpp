#include<iostream>
using namespace std;

class gameboard{
    private:
    char *board_;
    char *xo_;
    bool end;
    public:
    gameboard(){
        board_=new char[9];
        xo_=new char[2];
        xo_[0]=' ';
        xo_[1]=' ';
        bool 
        for(int i=0; i<9; i++){
            board_[i]=' ';
        }
    }
    ~gameboard(){
        delete [] board_;
        delete [] xo_;
    }

    int chooseplayer(){
        int player;
        cout<<"Wybierz gracza 0 lub 1"<<endl;
        do{
            cin>>player;
        }while(player!=0 && player!=1)
        return player;
    }
    
    void coutboard(){
        for(int i=0; i<9; i++){
            cout<<"["<<xo_<<"]"<<"\t";
            if(i==2||i==5){
                cout<<"\n";
            }
        }
    };
    void game(){
        
    }

};

int main(){
}
