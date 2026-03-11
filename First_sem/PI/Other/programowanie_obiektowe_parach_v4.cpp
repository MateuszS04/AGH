#include<iostream>
#include<cstring>
using namespace std;

class fib{
    protected:
    size_t size_;
    int *tab_;
    public:
    fib(size_t size){
        size_=size;
        if(size<2){
            cout<<"za mały rozmiar"<<endl;
        }else{
        tab_=new int[size_];
        tab_[0]=1;
        tab_[1]=1;        
        for(size_t i=2; i<size_; i++){
            tab_[i]=tab_[i-1]+tab_[i-2];
        }
        }
    }
    void add(){
        if(size_>2){
        int *tab2=new int [size_ +1];
        memcpy(tab2,tab_,size_*sizeof(int));
        delete []tab_;
        tab2[size_]=tab2[size_-1] + tab2[size_-2];
        tab_=new int[size_+1];
        memcpy(tab_,tab2,(size_+1)*sizeof(int));
        delete[]tab2;
        size_++;
        }else{
            cout<<"za mały rozmiar tablicy"<<endl;
        }
        
    }
        void print(){
        if(size_>2){
        for(size_t i=0; i<size_; i++){
            cout<<tab_[i]<<',';
        }
        cout<<endl;
        }
        }
    ~fib(){
        if(size_>2){
        delete [] tab_;
       }
    }
};
class fib_start:public fib{
    private:
    int a_;
    int b_;
    public:
    fib_start(size_t size, int a, int b)
    :fib(size){
        if(size>2){
        tab_[0]=a;
        tab_[1]=b;
        for(size_t i=2; i<size; i++){
            tab_[i]=tab_[i-1]+tab_[i-2];
        }
        }
    }
    void remove(){
        if(size_<2){  
            cout<<"za krótki ciąg"<<endl;
        }else{      
        int *tab3=new int[size_-1];
        for(size_t i=1; i<size_;i++){
            tab3[i-1]=tab_[i];
        }
        delete [] tab_;
        tab_=new int[size_-1];
        memcpy(tab_,tab3,size_*sizeof(int));
        delete [] tab3;
        --size_;
        }
  
    }
    ~fib_start(){
    }
};
int main(){
    fib p(3);
    p.add();
    p.print();
    fib_start q(5,3,-5);
    q.print();
    q.remove();
    q.print();
}