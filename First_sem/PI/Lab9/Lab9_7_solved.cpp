#include<iostream>
#include<cstring>
using namespace std;

class CD{
    private:
    bool in_;
    protected:
    char *content_;
    size_t size_;
    public:
    CD(const char* data){
        size_=10;
        content_=new char[size_];
        in_=false;

        strncpy(content_, data, size_);
        content_[size_];
    }
    void read(){
        if(in_){
            cout<<"Reading data pleas wait"<<endl;
        }else{
            cout<<"Eror pleas insert disc"<<endl;
        }

    }
    void in_out(bool insert){
        in_=insert;
        if(insert){
            cout<<"Disc inside"<<endl;
        }else{
            cout<<"Disc not inserted"<<endl;
        }
    }
    ~CD(){
        delete[] content_;
    }

};
class CDRW:public CD{
    public:
    CDRW(const char* data)
    :CD(data){
    }
    void write(){
         if(this){
            for(int i=0; i<size_; i++){
                cout<<content_[i];
            }
        }else{
            cout<<"Error, pleas insert the disc";
        }
        cout<<endl;
    }
};
class BR:public CDRW{
    public:
    BR(const char* data)
    :CDRW(data){
        size_=20;
        newsize(size_);
    }
    void newsize( size_t size2){
        char* newContent=new char[size2];
        strncpy(newContent, content_, size_);
        delete[] content_;
        content_=newContent;
    }

};

int main(){
    CD p("Example");
    p.in_out(true);
    p.read();
    CDRW q("Example");
    q.write();
    BR e("Example of using");
}