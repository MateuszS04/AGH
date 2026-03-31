class Solution(object):
    def findMaxConsecutiveOnes(self, nums):
        """
        :type nums: List[int]
        :rtype: int
        """
        ans=[]
        j=0
        i=0
        while i < len(nums):
            if  nums[i]==1 and nums[i-1]==1 or nums[i]==1:
                j+=1
                ans.append(j)                
            elif nums[i]==0:
                j=0
            i+=1
        if ans:    
            result=max(ans)
        else :
            return 0
        return result
    
k=Solution()
print(k.findMaxConsecutiveOnes(nums=[1,1,0,1,1,1]))