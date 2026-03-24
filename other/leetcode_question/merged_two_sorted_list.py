
# Definition for singly-linked list.
class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

    def buildList(self,values):
        dummy=ListNode()
        curr=dummy
        for v in values:
            curr.next=ListNode(v)
            curr=curr.next
        return dummy.next
    def print_list(self,node):
        vals=[]
        while node:
            vals.append(str(node.val))
            node=node.next
        return "->".join(vals)
    

class Solution(object):
    def mergeTwoLists(self, list1, list2):
        dummy=ListNode()
        tail=dummy
        while list1 and list2:
            if list1.val<list2.val:
                tail.next=list1
                list1=list1.next
            else:
                tail.next=list2
                list2=list2.next
            tail=tail.next
        tail.next=list1 if list1 else list2
        return dummy.next 


def main():
    k=Solution()
    p=ListNode()
    list1 =p.buildList([1,2,4]) 
    list2 = p.buildList([1,3,4])
    result=k.mergeTwoLists(list1,list2)
    print(p.print_list(result))


if __name__=='__main__':
    main()