#include <iostream>
using namespace std;
void write(int *tab, size_t size);

int main(){
  size_t size;
  cin >> size;
  int *tab = new int[size];
  
  write(tab, size);
  for(int i = 0; i < size; ++i){
    cout << *(tab + i) << endl;
  }
  delete[] tab;
}

void write(int *tab, size_t size){
  for(int i = 0; i < size; ++i){
    *(tab + i) = i;
  }
}
