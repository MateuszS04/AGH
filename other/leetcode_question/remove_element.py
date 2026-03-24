class Solution(object):
    def removeElement(self, nums, val):
        k=0
        i=0

        while i<len(nums):
            if nums[i]==val:
                nums.pop(i)
                k+=1
            else:
                i+=1
        nums.extend(['_']*k)
        return i


def main():
    s=Solution()
    nums=[0,1,2,2,3,0,4,2]
    val=2
    print(s.removeElement(nums,val))


if __name__=='__main__':
    main()



    
                
