class Solution(object):
    def removeDuplicates(self, nums):
        numbers=set()
        idx=0
        length_numbers=len(nums)


        for number in nums:
            if number not in numbers:
                nums[idx]=number
                numbers.add(number)
                idx+=1

        for i in range(idx,length_numbers):
            nums[i]='_'

        return idx


def main():
    s=Solution()
    nums=[0,0,1,1,1,2,2,3,3,4]
    print(s.removeDuplicates(nums))


if __name__=="__main__":
    main()
        






        