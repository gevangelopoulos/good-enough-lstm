function [results] = huffman_test(x,WL,sparsity_amount)
%WL=10;
startup;

%sparsify
%sparsity_amount=100;
 x(abs(x)<prctile(reshape(abs(x),[],1),sparsity_amount))=0;
%quantize
%T=numerictype(1, WL, max(x(:))/(2^(WL-1)-1), 0); %Creates best scaling for w* for a given WL
%fw=quantize(fi(x), T);
%%take stored integers
%A=fw.int;
n1=ceil(log2(max(x(:))+1));
n2=real(ceil(log2(min(x(:)))));

nextp2=max(n1,n2);

A1=-2^(nextp2);
B1=2^(nextp2)-1;
C1=-1;
D1=1;


xq=((round(((x-A1)/(B1-A1)*(D1-C1)+C1)*2^WL)/2^WL)-C1)*(B1-A1)/(D1-C1)+A1;


A=xq;
A=A(:);
A=A-min(A);

%create symbol table
C=unique(A);
%create a-posteriori probabilities for signals
D = zeros(size(C));
for i=1:length(C)
    D(i)=sum(A==C(i))/length(A);
end

%create dictionary
[dict avglen]=huffmandict(C,D);

%Encode the matrix
comp=huffmanenco(A,dict);
A=int32(A);
binA=de2bi(A);
binComp=de2bi(comp);

compression=numel(binComp)/numel(binA);
results = numel(binComp)
