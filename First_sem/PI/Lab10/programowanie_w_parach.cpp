#include<iostream>
#include<cstring>
using namespace std;

class fib{
	protected:
		int *tab_;
		int size_;
	public:
		fib(int size){
			size_=size;
			if(size_<2){
				cout<<"Błąd"<<endl;
				return;
			}
			tab_=new int[size];
			tab_[0]=0;
            tab_[1]=1;
			for(int i=2; i<size; i++){
				tab_[i]=tab_[i-2] +tab_[i-1];
			}
		}
        void add(){
            int *tab2=new int[size_ +1];
            memcpy(tab2, tab_, size_* sizeof(int));
            tab2[size_]=tab2[size_-2]+ tab2[size_ -1];
            delete[] tab_;
            tab_=tab2;
            size_++;            
        }
		void print(){
			for(int i=0; i<size_; i++){
				cout<<tab_[i]<<endl;
			}
			cout<<endl;
		}
    	~fib(){
			delete [] tab_;
        }
};
class fib_start:public fib{
	public:
	fib_start(int size, int a, int b)
	:fib(size){
		tab_[0]=a;
	    tab_[1]=b;
		for(int i=2; i<size; i++){
			tab_[i]=tab_[i-1]+tab_[i-2];
		}
	}
	void remove(){
		if(size_>1){
		int *tab3=new int[size_ -1];
		memcpy(tab3,tab_+1, (size_-1)*sizeof(int));
		delete [] tab_;
		tab_=tab3;
		size_--;
	}else {
		delete[] tab_;
		tab_=nullptr;
		size_=0;
	    }
	}
};
int main(){
  fib p(5);
  p.print();
  p.add();
  p.print();
  fib_start q(5,3,-5);
  q.print();
  q.remove();
  q.print();
  return 0;
}

