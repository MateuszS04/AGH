
class Solution(object):
    def isPalindrome(self, s):
        y=s.lower()
        y="".join(char for char in y if char.isalnum())
                
        x=y[::-1]

        if not y or x==y :
            return True
        else:
            return False



def main():
    k=Solution()
    s = "race a car"
    print(k.isPalindrome(s))
    

if __name__=='__main__':
    main()