sparsity=0;
sparsity_step=10;
numTrials=10;
results=[];
for i=1:numTrials
    sprintf('Running with Threshold:%f\n',sparsity)
    r=forward_pass_sparse(sparsity);
    results=[results; [sparsity r ]];
    
    sparsity=sparsity+sparsity_step;
end