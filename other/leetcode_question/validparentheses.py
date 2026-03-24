class Solution(object):
    def isValid(self, s):
        stack=[]
        mapping={")":"(","}":"{","]":"["}


        for char in s:
            if char in mapping:
                if stack :
                    top_element= stack.pop()
                else:
                    top_element='#'
                    return False
                if mapping[char]!=top_element:
                    return False
            else:
                stack.append(char)    
        return not stack
             


def main():
    s=Solution()
    x= input("Enter a string of parentheses: ")
    print(s.isValid(x))


if __name__== "__main__":
    main()

