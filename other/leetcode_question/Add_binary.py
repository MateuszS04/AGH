class Solution(object):
    def addBinary(self, a, b):
        a_len=len(a)
        b_len=len(b)
        counter_1=0
        counter_2=0
        sum=0
        b=b[::-1]
        b=list(b)
        a=a[::-1]
        a=list(a)
        for i in range(a_len):
            if a[i]=="1":
                counter_1+=(2**i)

        for j in range(b_len):
            if b[j]=="1":
                counter_2+=(2**j)
        sum=counter_1+counter_2
        result=bin(sum)
        result=result[2:]
        return result
    

        


def main():
    sol= Solution()
    a="11"
    b="1"
    print(sol.addBinary(a,b))



if __name__=='__main__':
    main()
