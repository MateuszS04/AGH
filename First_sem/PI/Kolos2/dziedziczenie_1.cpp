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
    }
    void in_out(bool insert){//wkładanie i wyjmowanie płyty przy użyciu funkcji logicznej
        in_=insert;
        if(in_){
            cout<<"disc inside"<<endl;
        }else{
            cout<<"please insert the disc"<<endl;
        }
    }
    void read(){
        if(in_){
            cout<<"reading the data"<<endl;
        }else{
            cout<<"please insert the disc"<<endl;
        }
    }
    ~CD(){
        delete [] content_;
    }
};
class CDRW:public CD{
    public:
    CDRW(const char* data)
    :CD(data){        
    strncpy(content_,data,size_);// kopijemy tablicę aby znalazły się w niej elementy umieszczone jako parametry w main
    content_[size_];
    }
    void write(){
        if(this){
            for(int i=0; i<size_; i++){//wypisujemy elementy tablicy, działa tylko jak ją skopiujemy w konstruktorze
                cout<<content_[i];
            }
        }else{
            cout<<"error"<<endl;
        }
        cout<<endl;
    }
};
class BR:public CDRW{
    public:
    BR(const char* data)
    :CDRW(data){
    }
    void newsize(){
        
    }
};


int main(){
    CD p("Example");
    p.in_out(true);
    p.read();
    CDRW q("Example");
    q.write();
    BR w("Exampleofsomethung");
    w.write();
}