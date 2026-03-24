import random

class Solution(object):
    def twoSum(nums, target):
        result=[]
        for i in range(len(nums)):
            x=target-nums[i]
            if x>0 and not result:
                for j in range(len(nums)):
                    if i!=j and x==nums[j] and not result:
                        result.append(i)
                        result.append(j)                      
        print(result)
                
p=[random.randint(0,10) for _ in range(10)]
print(p)
t=5
x=Solution
x.twoSum(p,t)

                