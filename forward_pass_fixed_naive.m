function [results] = forward_pass_fixed_naive(FILE,WL,FL)
fprintf(FILE,'Running LSTM fixed-point trial on TIMITs validation set...\n')
signed=1;

%WL=32;
%FL=25;
%Load and preprocess
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

w1=quantizenumeric(w1,signed,WL,FL,'round','saturate');
w2=quantizenumeric(w2,signed,WL,FL,'round','saturate');
w3=quantizenumeric(w3,signed,WL,FL,'round','saturate');
w4=quantizenumeric(w4,signed,WL,FL,'round','saturate');
w5=quantizenumeric(w5,signed,WL,FL,'round','saturate');
w6=quantizenumeric(w6,signed,WL,FL,'round','saturate');
w7=quantizenumeric(w7,signed,WL,FL,'round','saturate');
w8=quantizenumeric(w8,signed,WL,FL,'round','saturate');
feats=quantizenumeric(feats,signed,WL,FL,'round','saturate');
feats=reshape(feats,400,742,[]);

for seqNum=1:dsSize
    inputSequence=squeeze(feats(seqNum,:,:));
    %expectedSequence=squeeze(labels(seqNum,:));
    expectedSequence=labels(seqNum,1:seqLengths(seqNum));
    seqLength=seqLengths(seqNum);
    defaults= [1 0];
    F_i=[];F_f=[];F_z=[];F_c=[];F_o=[];F_h=[];
    B_i=[];B_f=[];B_z=[];B_c=[];B_o=[];B_h=[];
    predictedSequence=[];
    
    
    %sequence=dataset(seqNum)
    
    
    %Forward LSTM
    x=inputSequence';
    x=x(:,1:seqLength);
    y=fliplr(x(:,1:seqLength));
    
    %==Algorithm
    %seqLength=10;
    for t=1:seqLength
        %%Forward
        if t==1
            F_all_input_sums = w1*x(:,t)+w3*h0+w2;
        else
            F_all_input_sums = w1*x(:,t)+w3*F_h(:,t-1)+w2;
        end
        %Quantize
        F_all_input_sums=quantizenumeric(F_all_input_sums,signed,WL,FL,'round','saturate');
        
        F_n1=F_all_input_sums(1:hiddenSize);
        F_n2=F_all_input_sums(hiddenSize+1:2*hiddenSize);
        F_n3=F_all_input_sums(2*hiddenSize+1:3*hiddenSize);
        F_n4=F_all_input_sums(3*hiddenSize+1:4*hiddenSize);
        
        
        F_in_gate=sigmf(F_n1, defaults);
        F_in_transform=tansig(F_n2);
        F_forget_gate=sigmf(F_n3, defaults);
        F_out_gate=sigmf(F_n4, defaults);
        
        %Quantize
        F_in_gate=quantizenumeric(F_in_gate,signed,WL,FL,'round','saturate');
        F_in_transform=quantizenumeric(F_in_transform,signed,WL,FL,'round','saturate');
        F_forget_gate=quantizenumeric(F_forget_gate,signed,WL,FL,'round','saturate');
        F_out_gate=quantizenumeric(F_out_gate,signed,WL,FL,'round','saturate');
        
        if  t==1
            F_c(:,t)=F_forget_gate.*c0+F_in_gate.*F_in_transform; %why doesn't F_c become a fi?
        else
            F_c(:,t)=F_forget_gate.*F_c(:,t-1)+F_in_gate.*F_in_transform;
        end
        
%         %Quantize
         F_c(:,t)=quantizenumeric(F_c(:,t),signed,WL,FL,'round','saturate');
%         
        
        F_h(:,t)=F_out_gate.*tansig(F_c(:,t));
        
%         %Quantize
        F_h(:,t)=quantizenumeric(F_h(:,t),signed,WL,FL,'round','saturate');
        
        
        %%Backward
        if t==1
            B_all_input_sums = w4*y(:,t)+w6*h0+w5;
        else
            B_all_input_sums = w4*y(:,t)+w6*B_h(:,t-1)+w5;
        end
        %Quantize
         B_all_input_sums=quantizenumeric(B_all_input_sums,signed,WL,FL,'round','saturate');
        
        B_n1=B_all_input_sums(1:hiddenSize);
        B_n2=B_all_input_sums(hiddenSize+1:2*hiddenSize);
        B_n3=B_all_input_sums(2*hiddenSize+1:3*hiddenSize);
        B_n4=B_all_input_sums(3*hiddenSize+1:4*hiddenSize);
        
        
        B_in_gate=sigmf(B_n1, defaults);
        B_in_transform=tansig(B_n2);
        B_forget_gate=sigmf(B_n3, defaults);
        B_out_gate=sigmf(B_n4, defaults);
        
%         %Quantize
         B_in_gate=quantizenumeric(B_in_gate,signed,WL,FL,'round','saturate');
         B_in_transform=quantizenumeric(B_in_transform,signed,WL,FL,'round','saturate');
         B_forget_gate=quantizenumeric(B_forget_gate,signed,WL,FL,'round','saturate');
         B_out_gate=quantizenumeric(B_out_gate,signed,WL,FL,'round','saturate');
%         
        if  t==1
            B_c(:,t)=B_forget_gate.*c0+B_in_gate.*B_in_transform; %why doesn't B_c become a fi?
        else
            B_c(:,t)=B_forget_gate.*B_c(:,t-1)+B_in_gate.*B_in_transform;
        end
        
%         %Quantize
        B_c(:,t)=quantizenumeric(B_c(:,t),signed,WL,FL,'round','saturate');
%         
        
        B_h(:,t)=B_out_gate.*tansig(B_c(:,t));
        
%         %Quantize
         B_h(:,t)=quantizenumeric(B_h(:,t),signed,WL,FL,'round','saturate');
%         
%         %step(x_scope,x(:,t));
        %step(F_c_scope,F_c(:,t));
        %step(F_h_scope,F_h(:,t));
    end
    %Flip B_h
    B_h=fliplr(B_h); %B_h has to be flipped again. Check BiSequencer.lua and alex graves thesis algorithm 3.1
    for t=1:seqLength
        %    %Fully Connected Layer
        FC_input=cat(1,F_h(:,t),B_h(:,t));
        FC_output=w7*FC_input+w8;
       FC_output=quantizenumeric(FC_output,signed,WL,FL,'round','saturate');
        %step(FC_output_scope,FC_output);
        %    %Softmax
        %FC_output=softmax(FC_output);
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
    sprintf('FCE: %f',fce);
    sprintf('pass complete %d',seqNum);
    fce_list(seqNum)=fce;
end
Average_fce=fce_acc/seqNum;
sprintf('Average_fce:%f',Average_fce)
%end

fprintf(FILE,'dsSize=%d\n',dsSize);
fprintf(FILE,'WL=%d, FL=%d\n',WL,FL);
fprintf(FILE,'Average FCE=%f\n',Average_fce);
fprintf(FILE,'FCE List per utterance:\n')
fprintf(FILE,'%f\n',fce_list);
results=Average_fce;
%clear Average_fce fce_list
end
