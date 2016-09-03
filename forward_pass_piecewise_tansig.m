function [results]= forward_pass_piecewise_tansig(mode,xdata,ydata)
startup;
dsSize=80;
fce_acc=0;
defaults= [1 0];

for seqNum=1:dsSize
    inputSequence=squeeze(feats(seqNum,:,:));
    expectedSequence=labels(seqNum,1:seqLengths(seqNum));
    seqLength=seqLengths(seqNum);
    
    F_i=[];F_f=[];F_z=[];F_c=[];F_o=[];F_h=[];
    B_i=[];B_f=[];B_z=[];B_c=[];B_o=[];B_h=[];
    predictedSequence=[];
    
    c0=zeros(hiddenSize,1);
    h0=zeros(hiddenSize,1);
    
    %Forward LSTM
    x=inputSequence';
    x=x(:,1:seqLength);
    y=fliplr(x(:,1:seqLength));

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
        F_in_transform=piecewise_tansig(F_n2,mode, xdata,ydata);
        F_forget_gate=sigmf(F_n3,defaults);
        F_out_gate=sigmf(F_n4,defaults);
        
        if  t==1
            F_c(:,t)=F_forget_gate.*c0+F_in_gate.*F_in_transform;
        else
            F_c(:,t)=F_forget_gate.*F_c(:,t-1)+F_in_gate.*F_in_transform;
        end
        
        F_h(:,t)=F_out_gate.*piecewise_tansig(F_c(:,t),mode, xdata,ydata);
    
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
    B_in_transform=piecewise_tansig(B_n2,mode, xdata,ydata);
    B_forget_gate=sigmf(B_n3,defaults);
    B_out_gate=sigmf(B_n4,defaults);
    
    if t==1
        B_c(:,t)=B_forget_gate.*c0+B_in_gate.*B_in_transform;
    else
        B_c(:,t)=B_forget_gate.*B_c(:,t-1)+B_in_gate.*B_in_transform;
    end
        
    B_h(:,t)=B_out_gate.*piecewise_tansig(B_c(:,t),mode, xdata,ydata);
       
    end
%Flip B_h
B_h=fliplr(B_h); %B_h has to be flipped again. Check BiSequencer.lua and alex graves thesis algorithm 3.1
FC_softmax=[];
for t=1:seqLength
    %    %Fully Connected Layer
    FC_input=cat(1,F_h(:,t),B_h(:,t));
    FC_output=w7*FC_input+w8;
    %    %Softmax
    
    %FC_softmax(:,t)=softmax(FC_output);
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
%results=[total_sparsity average_fce];
%results=F_c;
results=average_fce;
end