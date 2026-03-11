#include<iostream>
using namespace std;

class vector2d{
    private:
    float *date_;
    public:
    vector2d(){
        date_=new float[2];
    }
    ~vector2d(){
        delete [] date_;
    }
    void setcoordinates(float x, float y){
        date_[0]=x;
        date_[1]=y;
    }
    float *getcoordinates(){
        return date_;
    }
    void print(){
        cout<<date_[0]<<endl;
        cout<<date_[1]<<endl;
        cout<<date_<<endl;;
    }
    void add(vector2d *vec){
        date_[0]+= vec->date_[0];
        date_[1] += vec->date_[1];
    }
    vector2d *vecaddress(){
        return this;
    }
    float *dateaddress(){
        return date_;
    }
};
int main(){
    vector2d p;
    p.setcoordinates(2,3);
    p.print();
}