from array import*
import time

def main():
    start=time.time()
    L=array('f',[1,2])
    for i in range(2,48):
        L.append((L[i-1]+L[i-2])/(L[i-1]-L[i-2]))
    print(L)
    avag=sum(L)/len(L)
    print(avag)
    print(max(set(L), key=L.count))    
    values = set([x for x in L if L.count(x)>1])
    if values:
        print("Apear more than once", values)
    else:
        print("none")
    end=time.time()
    print("time to execute :",end-start)



if __name__=="__main__":
    main()