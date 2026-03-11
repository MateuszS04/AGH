#include<iostream>
using namespace std;

int main(){
    int*x;
    int y=2;

    x=&y;//przypisujemy wskaźnikowi x adres zmiennej y
    x=y;//nie można przypisywać wartości y do wskaźnika
    *x=y;//zmiana wartości x i przypisanie wskaźnikowi nowej wartości co nie jest możliwe
    *x=&y;//przypisanie adresu y do miejsca w pamieci wskazanego przez x, nie można tak
}