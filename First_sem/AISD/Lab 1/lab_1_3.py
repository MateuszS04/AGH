import time
start1=time.time()
letters=['a','b','c','d','e','f']
for i in letters:
    print(i)
end1=time.time()
print(end1-start1)
print()
start2=time.time()
lst=['a','b','c','d','e','f']
for i in range(len(lst)):
    print(lst[i])
end2=time.time()
print(end2-start2)