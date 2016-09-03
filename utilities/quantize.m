A=0
B=8
C=-1
D=1

x=[6 3 ;4 0]
xn=(x-A)/(B-A)*(D-C)+C
xp=xn*2^n

xp=round(xn*2^n)

xn_prime=xp/2^n

xq=(xn-C)*(B-A)/(D-C)