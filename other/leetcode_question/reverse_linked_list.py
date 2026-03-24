class ListNode(object):
    def __init__(self,val=0,next=None):
        self.val=val
        self.next=next

    def buildList(self,head):
        dummy=ListNode()
        curr=dummy
        for v in head:
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
    def reverseList(self, head):
        curr=head
        while curr:
            

        

def main():
    k=Solution()
    p=ListNode()
    list = [1,2,3,4,5]
    head=p.buildList(list)
    print(p.printList(head))
    res=k.reverseList(head)
    print(p.printList(res))

if __name__=="__main__":
    main()
    


