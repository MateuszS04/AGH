class Solution(object):
    def strStr(self, haystack, needle):
        start=0
        stop=len(haystack)
        b=haystack.find(needle,start,stop)
        return b




        




def main():
    k=Solution()
    haystack = "sadbutsad" 
    needle = "sad"
    print(k.strStr(haystack,needle))

if __name__=='__main__':
    main()