class Solution(object):
    def plusOne(self, digits):
        delimiter=''


        num=int(delimiter.join(map(str,digits)))
        num+=1


        return [int(d) for d in str(num)]



def main():
    s=Solution()
    digits=[1,2,3]
    print(s.plusOne(digits))

if __name__=="__main__":
    main()
        


        

