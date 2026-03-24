class ListNode(object):
    def __init__(self, val=0,next=None):
        self.val=val
        self.next=next

    def buildList(self,values):
        dummy=ListNode()
        curr=dummy
        for v in values:
            curr.next=ListNode(v)
            curr=curr.next
        return dummy.next
    
    def printList(self,node):
        vals=[]
        while node:
            vals.append(str(node.val))
            node=node.next
        return "->".join(vals)


class Solution(object):
    def deleteDuplicates(self, head):
        dummy=ListNode(0,head)
        prev=dummy
        curr=head
        while curr: 
            if curr.next and curr.val==curr.next.val:
                while curr.next and curr.val==curr.next.val:
                    curr=curr.next
                prev.next=curr.next
            else:
                prev=prev.next
            curr=curr.next
        return dummy.next


def main():
    k=Solution()
    p=ListNode()
    head = [1,2,3,3,4,4,5]
    list1=p.buildList(head)
    print(p.printList(list1))
    result=k.deleteDuplicates(list1)
    print(p.printList(result))


if __name__=='__main__':
    main()
