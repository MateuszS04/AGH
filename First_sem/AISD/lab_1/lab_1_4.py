l=[1]
try:
    l[2]=1
except IndexError:
    print("Bad index")
try:
    c=1/0
except ZeroDivisionError:
    print("You can't divide by zero")

try:
    for i in range(len(a)):
        print(a)
except NameError:
    print("this varieble don't exist")


