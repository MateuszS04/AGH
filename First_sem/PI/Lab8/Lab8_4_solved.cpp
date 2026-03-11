#include<iostream>
using namespace std;

class vector2d{
	public:
		int x1;
		int x2;
		int x3;
		int x4;
		void print2d(){
			cout<<x1<<","<<x2<<endl;
		}
		void add(){
			cout<<x1+x3<<","<<x2+x4<<endl;
		}
		
};


int main(){
	vector2d p;
	p.x1=2;
	p.x2=3;
	p.x3=4;
	p.x4=5;
        p.print2d();
	p.add();
}
