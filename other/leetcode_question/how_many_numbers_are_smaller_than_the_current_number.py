class Solution(object):
    def smallerNumbersThanCurrent(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        ans=[]
        count=0
        for _ in nums:
            for i in range(len(nums)):
                if _ > nums[i]:
                    count+=1
            ans.append(count)
            count=0
        return ans
    

k=Solution()
print(k.smallerNumbersThanCurrent(nums=[7,7,7,7]))

            