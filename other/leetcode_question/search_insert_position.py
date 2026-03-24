class Solution(object):
    def searchInsert(self, nums, target):
        i=0
        k=0
        while i<len(nums):
            if nums[i]==target:
                k=i
                break
            elif ( i==(len(nums)-1) or nums[i+1]>target ) and nums[i]<target:
                k=i+1
                nums.insert(k,target)
                break
            else: 
                i+=1

        return k

def main():
    s=Solution()
    nums=[1,3,5,6]
    target=7
    print(s.searchInsert(nums,target))

if __name__=='__main__':
    main()



        

        