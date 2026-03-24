class Solution(object):
    def merge(self, nums1, m, nums2, n):

        i = m - 1
        j = n - 1
        k = m + n - 1  

        while i >= 0 and j >= 0:
            if nums1[i] > nums2[j]:
                nums1[k] = nums1[i]
                i -= 1
            else:
                nums1[k] = nums2[j]
                j -= 1
            k -= 1

        while j >= 0:
            nums1[k] = nums2[j]
            j -= 1
            k -= 1

        return nums1

def main():
    s=Solution()
    nums1=[1,2,3,0,0,0]
    nums2=[2,5,6]
    m=3
    n=3
    print(s.merge(nums1,m,nums2,n))

if __name__=="__main__":
    main()





# class Solution(object):
#     def merge(self, nums1, m, nums2, n):
#         i=0   

#         if n!=0:
#             while i<n+m:
#                 for j in range(n):
#                     if (nums1[i]<=nums2[j])  and (i==len(nums1)-1 or (nums1[i+1]>=nums2[j]) or nums1[i+1]==0):
#                         nums1.insert(i+1,nums2[j])
#                         i+=1
#                     else:
#                         i+=1    
        
#         nums1=[k for k in nums1 if k!=0]        
#         return nums1