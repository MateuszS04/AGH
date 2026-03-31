class Solution(object):
    def getConcatenation(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        n=len(nums)
        ans=[]
        for i in range(n):
            ans.append(nums[i])
            if len(ans)==len(nums):
                for i in range(n):
                    ans.append(nums[i])
        return ans


k=Solution()
print(k.getConcatenation(nums=[1,2,1]))

