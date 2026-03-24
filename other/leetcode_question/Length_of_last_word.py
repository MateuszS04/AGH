class Solution(object):
    def lengthOfLastWord(self, s):
        a=s.split()  
        i=0
        for char in a[-1]:
            i+=1
        return i

       




def main():
    k=Solution()
    s="Hello man"
    print(k.lengthOfLastWord(s))


if __name__== '__main__':
    main()
