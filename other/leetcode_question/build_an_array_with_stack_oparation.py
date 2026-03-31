class Solution(object):
    def buildArray(self, target, n):
        output=[]
        pu="Push"
        po="Pop"
        j=0

        while j<len(target):
            for i in range(1,n+1):            
                if i== target[j]:
                    output.append(pu)
                    j+=1
                    if j==len(target):
                        return output
                else:
                    output.append(pu)
                    output.append(po)
                
        return output
        
k=Solution()
print(k.buildArray(target=[1,3],n=3))