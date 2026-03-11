import random
import time

def inertionsort(A):
    for i in range(1,len(A)-1):
        x=A[i]
        j=i-1
        while j>=0 and A[j]>x:
            A[j+1]=A[j]
            j=j-1
        A[j+1]=x

def mergesort(A,a,b):#a-indeks pierwszego elementu b-indeks ostatniego elementu
    if a<b:
        c=int((a+b)/2)               #indeks środkowego elementu
        mergesort(A,a,c)
        mergesort(A,c+1,b)
        merge(A,a,c,b)

def merge(A,a,c,b):
    left_half=a     #indeks pierwzego elementu pierwszej połowy
    right_half=c+1 #indeks pierwszego elementu drugiej połowy
    result=[]

    while left_half<=c and right_half<=b:
        if A[left_half]<A[right_half]:       #łączenie list w jedną
            result.append(A[left_half])
            left_half+=1
        else:
            result.append(A[right_half])
            right_half+=1
    while left_half<=c:
        result.append(A[left_half])
        left_half+=1
    while right_half<=b:
        result.append(A[right_half])
        right_half+=1
    for i in range(len(result)):
        A[a+i]=result[i]
    

A=[random.randint(0,999) for _ in range(10000)]
print(A)
print('\n')
start0=time.time()
inertionsort(A)
end0=time.time()
print(A)
print('\n')
start=time.time()
mergesort(A,0, len(A)-1)
end=time.time()
print(A)
print("Mergesort time : ",end-start)
print("Iteration sort time : ", end0-start0)

