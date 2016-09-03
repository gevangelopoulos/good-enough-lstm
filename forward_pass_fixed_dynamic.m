%%Forward Pass fixed-point 3
%This function quantizes w* to a smaller wordlength and encodes the maximum
%and minimum values by adjusting the slope of the quantization

function [results] = forward_pass_fixed_dynamic(FILE,WL)
fprintf(FILE,'Running LSTM fixed-point trial on TIMITs validation set...\n')
signed=1;

startup;
dsSize=80
fce_acc=0;


inputSize=size(w1);
inputSize=inputSize(2);
hiddenSize=size(w1);
hiddenSize=hiddenSize(1)/4;
outputSize=size(w8);
c0=zeros(hiddenSize,1);
h0=zeros(hiddenSize,1);

[w1 w2 w3 w4 w5 w6 w7 w8 feats] = quantize_weights(WL,w1,w2,w3,w4,w5,w6,w7,w8, feats);


for seqNum=1:dsSize
    inputSequence=squeeze(feats(seqNum,:,:));
    expectedSequence=labels(seqNum,1:seqLengths(seqNum));
    seqLength=seqLengths(seqNum);
    defaults= [1 0];
    F_i=[];F_f=[];F_z=[];F_c=[];F_o=[];F_h=[];
    B_i=[];B_f=[];B_z=[];B_c=[];B_o=[];B_h=[];
    predictedSequence=[];
    
    
 
    %Forward LSTM
    x=inputSequence';
    x=x(:,1:seqLength);
    y=fliplr(x(:,1:seqLength));
    
    %==Scoping
    %Scopes should be places on input output and intermediate variables to see
    %how the calculations progress.
    
    
    
    %==Algorithm
    for t=1:seqLength
        %%Forward
        if t==1
            F_all_input_sums = w1*x(:,t)+w3*h0+w2;
        else
            F_all_input_sums = w1*x(:,t)+w3*F_h(:,t-1)+w2;
        end
    
        
        F_n1=F_all_input_sums(1:hiddenSize);
        F_n2=F_all_input_sums(hiddenSize+1:2*hiddenSize);
        F_n3=F_all_input_sums(2*hiddenSize+1:3*hiddenSize);
        F_n4=F_all_input_sums(3*hiddenSize+1:4*hiddenSize);
        
        
        F_in_gate=sigmf(F_n1, defaults);
        F_in_transform=tansig(F_n2);
        F_forget_gate=sigmf(F_n3, defaults);
        F_out_gate=sigmf(F_n4, defaults);
        
      
        if  t==1
            F_c(:,t)=F_forget_gate.*c0+F_in_gate.*F_in_transform;
        else
            F_c(:,t)=F_forget_gate.*F_c(:,t-1)+F_in_gate.*F_in_transform;
        end
        
       
        
        F_h(:,t)=F_out_gate.*tansig(F_c(:,t));
        
        
        
        %%Backward
        if t==1
            B_all_input_sums = w4*y(:,t)+w6*h0+w5;
        else
            B_all_input_sums = w4*y(:,t)+w6*B_h(:,t-1)+w5;
        end
        
        B_n1=B_all_input_sums(1:hiddenSize);
        B_n2=B_all_input_sums(hiddenSize+1:2*hiddenSize);
        B_n3=B_all_input_sums(2*hiddenSize+1:3*hiddenSize);
        B_n4=B_all_input_sums(3*hiddenSize+1:4*hiddenSize);
        
        
        B_in_gate=sigmf(B_n1, defaults);
        B_in_transform=tansig(B_n2);
        B_forget_gate=sigmf(B_n3, defaults);
        B_out_gate=sigmf(B_n4, defaults);
        
        
        if  t==1
            B_c(:,t)=B_forget_gate.*c0+B_in_gate.*B_in_transform; %why doesn't B_c become a fi?
        else
            B_c(:,t)=B_forget_gate.*B_c(:,t-1)+B_in_gate.*B_in_transform;
        end
  
        
        B_h(:,t)=B_out_gate.*tansig(B_c(:,t));
        
    end
    %Flip B_h
    B_h=fliplr(B_h); %B_h has to be flipped again. Check BiSequencer.lua and alex graves thesis algorithm 3.1
    for t=1:seqLength
        %    %Fully Connected Layer
        FC_input=cat(1,F_h(:,t),B_h(:,t));
        FC_output=w7*FC_input+w8;
        %step(FC_output_scope,FC_output);
        %    %Softmax
        %FC_output=softmax(FC_output);
        %    %Decision Policy: Max
        [M,I] = max(FC_output);
        
        predictedSequence(t)=I;
        

    end
    sum=0;
    for i=1:seqLength
        if predictedSequence(i)==expectedSequence(i)
            sum=sum+1;
        end
    end
    fce=(1-sum/seqLength)*100;
    fce_acc=fce_acc+fce;
    sprintf('FCE: %f',fce);
    sprintf('pass complete %d',seqNum);
    fce_list(seqNum)=fce;
end
Average_fce=fce_acc/seqNum;
sprintf('Average_fce:%f',Average_fce)

fprintf(FILE,'dsSize=%d\n',dsSize);
fprintf(FILE,'WL=%d\n',WL);
fprintf(FILE,'Average FCE=%f\n',Average_fce);
fprintf(FILE,'FCE List per utterance:\n')
fprintf(FILE,'%f\n',fce_list);
results=Average_fce;
%clear Average_fce fce_list
end
