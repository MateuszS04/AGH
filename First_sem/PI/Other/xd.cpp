#include <iostream>
using namespace std;
int main()
{
	int tab[100];
	for (int i = 0; i < 100; i++) {
		cout << "Podaj element " << i + 1 << ": " << endl;
		cin >> tab[i];
		if (tab[i] < 0) {
			tab[i] = 0;
			break;
		}
	}
	for (int i = 0; i < 100; i++) {
		double pierwiastek = sqrt(tab[i]);
		for (int j = 0; j < 100; j++) {
			if (pierwiastek == tab[j]&& tab[j]>0) {
				cout << tab[j] << " jest pierwiastkiem z " << tab[i]<<endl;
			}
		}
	}
}
