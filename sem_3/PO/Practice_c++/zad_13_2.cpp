#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

#define N 10000 //Liczba generowanych próbek
#define RAND_MAX 32767 //Maksymalna wartość generowana przez rand()

static unsigned long next=1;

int rand(void){
    next=next*1103515245+12345;//x(n+1)=a*x(n)+m
    return(unsigned)(next/65536)%32768;
}

void srand(unsigned seed){
    next=seed;
}

int find_period(int *sequence, int size) {
    for (int k = 1; k < size; ++k) {
        bool is_periodic = true;
        for (int i = 0; i < size - k; ++i) {
            if (sequence[i] != sequence[i + k]) {
                is_periodic = false;
                break;
            }
        }
        if (is_periodic) {
            return k; // znaleziono okres
        }
    }
    return -1; // brak okresu w zakresie próbek N
}
void calculate_histogram(int *sequence, int size, int bins) {
    int counts[bins];
    for (int i = 0; i < bins; ++i) {
        counts[i] = 0;
    }

    // Liczenie liczby wystąpień w każdym przedziale
    for (int i = 0; i < size; ++i) {
        int bin = sequence[i] * bins / (RAND_MAX + 1);
        counts[bin]++;
    }

    // Wyświetlenie histogramu
    printf("Histogram:\n");
    for (int i = 0; i < bins; ++i) {
        printf("Bin %2d: %5d\n", i, counts[i]);
    }
}

int main(){
    int sequence[N];
    int seed=12345;
    srand(seed);

    for(int i=0;i<N;++i){
        sequence[i]=rand();
    }

    int period=find_period(sequence,N);

    if(period>0){
        printf("Okres generowanej sekwencji: %d\n");
    }else{
        printf("okres nie został znaleziony");
    }

        // Test powtarzalności
    srand(seed);
    printf("\nTest powtarzalności:\n");
    printf("Pierwsze 10 liczb przy ziarniu %u:\n", seed);
    for (int i = 0; i < 10; i++) {
        printf("%d ", rand());
    }
    printf("\n");

    // Test różnorodności (inne ziarno)
    srand(seed + 1);
    printf("\nPierwsze 10 liczb przy ziarniu %u:\n", seed + 1);
    for (int i = 0; i < 10; i++) {
        printf("%d ", rand());
    }
    printf("\n");

    calculate_histogram(sequence, N, 20);

}