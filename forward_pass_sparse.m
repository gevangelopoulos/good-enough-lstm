function [results]= forward_pass_sparse(sparsity_amount)
startup;
dsSize=80;
fce_acc=0;
%x_scope=NumericTypeScope;
%F_c_scope=NumericTypeScope;
%F_h_scope=NumericTypeScope;
%FC_output_scope=NumericTypeScope;

%Thresholding
    %select the N elements of w* that need to be set to zero in order to 
    %for the matrix to meet desired sparsity_amount, using the percentile method
    w1(abs(w1)<prctile(reshape(abs(w1),[],1),sparsity_amount))=0;
    w2(abs(w2)<prctile(reshape(abs(w2),[],1),sparsity_amount))=0;
    w3(abs(w3)<prctile(reshape(abs(w3),[],1),sparsity_amount))=0;
    w4(abs(w4)<prctile(reshape(abs(w4),[],1),sparsity_amount))=0;
    w5(abs(w5)<prctile(reshape(abs(w5),[],1),sparsity_amount))=0;
    w6(abs(w6)<prctile(reshape(abs(w6),[],1),sparsity_amount))=0;
     w7(abs(w7)<prctile(reshape(abs(w7),[],1),sparsity_amount))=0;
     w8(abs(w8)<prctile(reshape(abs(w8),[],1),sparsity_amount))=0;
 
    total_sparsity=(nnz(w1)+nnz(w2)+nnz(w3)+nnz(w4)+nnz(w5)+nnz(w6)...
        +nnz(w7)+nnz(w8))...
        /(prod(size(w1))+prod(size(w2))+prod(size(w3))+prod(size(w4))+...
        prod(size(w5))+prod(size(w6))+prod(size(w7))+prod(size(w8)));
for seqNum=1:dsSize
    inputSequence=squeeze(feats(seqNum,:,:));
    %expectedSequence=squeeze(labels(seqNum,:));
    expectedSequence=labels(seqNum,1:seqLengths(seqNum));
    seqLength=seqLengths(seqNum);
    defaults= [1 0];
    F_i=[];F_f=[];F_z=[];F_c=[];F_o=[];F_h=[];
    B_i=[];B_f=[];B_z=[];B_c=[];B_o=[];B_h=[];
    predictedSequence=[];
    
    c0=zeros(hiddenSize,1);
    h0=zeros(hiddenSize,1);
    %sequence=dataset(seqNum)
    
    
    %Forward LSTM
    x=inputSequence';
    x=x(:,1:seqLength);
    y=fliplr(x(:,1:seqLength));
    
    %==Scoping
    %Scopes should be places on input output and intermediate variables to see
    %how the calculations progress.
    %==FixedPoint Casting
    %all Ws should be cast to a specific type and be made fi objects.
    %also x and y and h and c.
    %add/mul with these variables will automatically result in fi objects.
    %the sigmoids should probably use the data of the fi objects cast
    %doubles and then requantized. After each iteration, c, and h should be
    %requantized, i think.
    %FC_output should also be quantized before taking the maximum and
    %performing classification.
    %Then we will examine the FCE of the Fixed-Precision against floating
    %point, and then we'll sweep.
%     w1=single(w1);
%     w2=single(w2);
%     w3=single(w3);
%     w4=single(w4);
%     w5=single(w5);
%     w6=single(w6);
%     w7=single(w7);
%     w8=single(w8);
%     x=single(x);
%     y=single(y);
%     h0=single(h0);
%     c0=single(c0);



%step(x_scope,w1)

    %==Algorithm
    A=[];
    for t=1:seqLength
    %Forward    
        if t==1
            F_all_input_sums = w1*x(:,t)+w3*h0+w2;
        else
            F_all_input_sums = w1*x(:,t)+w3*F_h(:,t-1)+w2;
        end
        
        F_n1=F_all_input_sums(1:hiddenSize);
        F_n2=F_all_input_sums(hiddenSize+1:2*hiddenSize);
        F_n3=F_all_input_sums(2*hiddenSize+1:3*hiddenSize);
        F_n4=F_all_input_sums(3*hiddenSize+1:4*hiddenSize);
        
        F_in_gate=sigmf(F_n1,defaults);
        F_in_transform=tansig(F_n2);
        F_forget_gate=sigmf(F_n3,defaults);
        F_out_gate=sigmf(F_n4,defaults);
        
        if  t==1
            F_c(:,t)=F_forget_gate.*c0+F_in_gate.*F_in_transform;
        else
            F_c(:,t)=F_forget_gate.*F_c(:,t-1)+F_in_gate.*F_in_transform;
        end
        
        F_h(:,t)=F_out_gate.*tansig(F_c(:,t));
    
    A=[A; max(max(F_all_input_sums))];
    %Backward
    if t==1
        B_all_input_sums = w4*y(:,t)+w6*h0+w5;
    else
        B_all_input_sums = w4*y(:,t)+w6*B_h(:,t-1)+w5;
    end
    
    B_n1=B_all_input_sums(1:hiddenSize);
    B_n2=B_all_input_sums(hiddenSize+1:2*hiddenSize);
    B_n3=B_all_input_sums(2*hiddenSize+1:3*hiddenSize);
    B_n4=B_all_input_sums(3*hiddenSize+1:4*hiddenSize);

    B_in_gate=sigmf(B_n1,defaults);
    B_in_transform=tansig(B_n2);
    B_forget_gate=sigmf(B_n3,defaults);
    B_out_gate=sigmf(B_n4,defaults);
    
    if t==1
        B_c(:,t)=B_forget_gate.*c0+B_in_gate.*B_in_transform;
    else
        B_c(:,t)=B_forget_gate.*B_c(:,t-1)+B_in_gate.*B_in_transform;
    end
        
    B_h(:,t)=B_out_gate.*tansig(B_c(:,t));
       
    %step(x_scope,x(:,t));
    %step(F_c_scope,F_c(:,t));
    %step(F_h_scope,F_h(:,t));
    end
%Flip B_h
B_h=fliplr(B_h); %B_h has to be flipped again. Check BiSequencer.lua and alex graves thesis algorithm 3.1
FC_softmax=[];
for t=1:seqLength
    %    %Fully Connected Layer
    FC_input=cat(1,F_h(:,t),B_h(:,t));
    FC_output=w7*FC_input+w8;
    %step(FC_output_scope,FC_output);
    %    %Softmax
    
    FC_softmax(:,t)=softmax(FC_output);
    %    %Decision Policy: Max
    [M,I] = max(FC_output);
    
    predictedSequence(t)=I;
    
    %
    %
    %
end
sum=0;
for i=1:seqLength
    if predictedSequence(i)==expectedSequence(i)
        sum=sum+1;
    end
end
fce=(1-sum/seqLength)*100;
fce_acc=fce_acc+fce;
sprintf('FCE: %f',fce)
sprintf('pass complete %d',seqNum)
fce_list(seqNum)=fce;
end
average_fce=fce_acc/seqNum;
sprintf('Average_fce:%f',average_fce)
results=[total_sparsity average_fce];
%results=F_c;
%results=average_fce;
end
