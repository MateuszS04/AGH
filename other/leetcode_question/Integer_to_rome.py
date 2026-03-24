class Solution(object):
    def intToRoman(self, num) -> str:
        if num> 3999 or num==0:
            return
        result=[]
        dictionary_numbers=[(1000,'M'),(900,'CM'),(500,'D'),(400,'CD'),(100,'C'),(90,'XC'),(50,'L'),
                            (40,'XL'),(10,'X'),(9,'IX'),(5,'V'),(4,'IV'),(1,'I')]
        for val, symbol in dictionary_numbers:
            count=num//val
            result.append(symbol*count)
            num-= count*val
        return ''.join(result)

        
def main():
    k=Solution()
    print(k.intToRoman(num = 1994))

if __name__=="__main__":
    main()