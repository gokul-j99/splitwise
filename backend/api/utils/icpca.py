

n = int(input())

a =[]
for i in range(n):
	ai  = list(map(int,input().split()))

for i in range(n):
	for j in range(n):
		if a[i][j] !=-1:
			print(i,end=" ")
			print(j,end=" ")
			print(a[i][j])