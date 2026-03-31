class Solution(object):
    def findErrorNums(self, nums):
        """
        :type nums: List[int]
        :rtype: List[int]
        """
        num_rep=0
        i=0
        number=0
        p=0
        j=0
        nums.sort()

        while i<len(nums) and p<1:
            if nums[i]== nums[i-1]:
                num_rep=int(nums[i])
                nums.remove(nums[i])
                p+=1
            i+=1

        while j<len(nums):
            k=nums[j]-nums[j-1]
            if k>1 or (k==0 and nums[0]==1):
                number=int(nums[j-1])+1
                p-=1
            elif nums[0]!=1:
                number = 1
                p-=1
            j+=1
        if p==1:
            number=nums[-1]+1
        return [num_rep,number]
    
k=Solution()
print(k.findErrorNums(nums=[1,3,3]))

        


