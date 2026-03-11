#include<iostream>
using namespace std;

class board{
    protected:
    char *tab_;
    public:    
    void printboard(){
        for(int i=0; i<3; i++){
            for(int j=0; j<3;j++){
                cout<<'['<<' '<<']';
            }
            cout<<endl;
        }
    }
};
int main(){
    board a;
    a.printboard();
}
