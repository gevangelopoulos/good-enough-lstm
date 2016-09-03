x=[164 5 ;0.12 -7]
%  
% 2^(n-1)-1>= max(x(:))
%-2^(n-1)  <= min(x(:))
%
n1=ceil(1+log2(max(x(:))+1));
n2=real(1+ceil(log2(min(x(:)))));

nextp2=max(n1,n2);

A=-2^(nextp2-1);
B=2^(nextp2-1)-1;
C=-1;
D=1;

WL=5;

xn=(x-A)/(B-A)*(D-C)+C; %map to -1 1
xp=round(xn*2^WL); %round
xn_prime=xp/2^WL; %divide
xq=(xn_prime-C)*(B-A)/(D-C)+A %rescale back