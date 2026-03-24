# Definition for a binary tree node.
class TreeNode(object):
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right



class Solution(object):
    
    def __init__(self):
        self.result=[]
    def sortedArrayToBST(self, nums):
        if not nums:
            return None
        mid=len(nums)//2
        val=nums[mid]
        self.result.append(val)  #wybieramy środkową wartość jako węzeł drzewa 
        root=TreeNode(val)
        root.left=self.sortedArrayToBST(nums[:mid])#reukrencyjnie tworzymy lewą i prawą gałąź drzewa wybierając środkowy element z drzewa po lewej stronie
        root.right=self.sortedArrayToBST(nums[mid+1 :])#tak samo tylko dla elementów po prawej od środka 
        return root


def main():
    s=Solution()
    nums=[0,1,2,3,4,5,6,7]
    s.sortedArrayToBST(nums)
    print(s.result)

if __name__=="__main__":
    main()