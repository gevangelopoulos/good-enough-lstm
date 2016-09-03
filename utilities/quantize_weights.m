function [w1q w2q w3q w4q w5q w6q w7q w8q featsq] = quantize_weights(WL,w1,w2,w3,w4,w5,w6,w7,w8,feats)

%Quantize weights
x=[w1(:) ; w2(:); w3(:); w4(:); w5(:); w6(:); w7(:); w8(:)];

n1=ceil(log2(max(x(:))+1));
n2=real(ceil(log2(min(x(:)))));

nextp2=max(n1,n2);

A=-2^(nextp2);
B=2^(nextp2)-1;
C=-1;
D=1;


w1q=((round(((w1-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w2q=((round(((w2-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w3q=((round(((w3-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w4q=((round(((w4-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w5q=((round(((w5-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w6q=((round(((w6-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w7q=((round(((w7-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
w8q=((round(((w8-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;
%w7q=w7;
%w8q=w8;

%Quantize feats
x=feats(:);
n1=ceil(log2(max(x(:))+1));
n2=real(ceil(log2(min(x(:)))));

nextp2=max(n1,n2);

A=-2^(nextp2);
B=2^(nextp2)-1;
C=-1;
D=1;
featsq=((round(((feats-A)/(B-A)*(D-C)+C)*2^WL)/2^WL)-C)*(B-A)/(D-C)+A;

