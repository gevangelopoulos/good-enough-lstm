startup;

sparsity=0;
sparsity_step=10;
numTrials=10;
results=[];
WL=4;
x=w3;
x=[w1(:) ; w2(:); w3(:); w4(:); w5(:); w6(:); w7(:); w8(:)];
s=whos('x');

results=[results; 0 64 s.bytes*8];
results=[results; 0 32 s.bytes*4];
for i=1:numTrials
    r= huffman_test(x,WL,sparsity);
    results= [results; sparsity WL r];
    
    sparsity=sparsity+sparsity_step;
end

%also plot relative compression, absolute compression and compression
%improvement vs WL.
%For WL1=10, WL2=8, WL1/WL2=1.25, but comp1/comp2=1.30. This mens that
%huffman finds more opportunities than linear reduction