inputSize=size(w1);
inputSize=inputSize(2);
hiddenSize=size(w1);
hiddenSize=hiddenSize(1)/4;
outputSize=size(w8);

%%Forward LSTM parameters
%Input to hidden
F_W=w1;
F_W_i=F_W(1:hiddenSize,:);
F_W_h=F_W(hiddenSize+1:2*hiddenSize,:);
F_W_f=F_W(2*hiddenSize+1:3*hiddenSize,:);
F_W_o=F_W(3*hiddenSize+1:4*hiddenSize,:);

%Hidden to hidden
F_R=w3;
F_R_i=F_R(1:hiddenSize,:);
F_R_h=F_R(hiddenSize+1:2*hiddenSize,:);
F_R_f=F_R(2*hiddenSize+1:3*hiddenSize,:);
F_R_o=F_R(3*hiddenSize+1:4*hiddenSize,:);

%Biases
F_b=w2;
F_b_i=F_b(1:hiddenSize);
F_b_h=F_b(hiddenSize+1:2*hiddenSize);
F_b_f=F_b(2*hiddenSize+1:3*hiddenSize);
F_b_o=F_b(3*hiddenSize+1:4*hiddenSize);

%%Backward LSTM parameters
%Input to hidden
B_W=w4;
B_W_i=B_W(1:hiddenSize,:);
B_W_h=B_W(hiddenSize+1:2*hiddenSize,:);
B_W_f=B_W(2*hiddenSize+1:3*hiddenSize,:);
B_W_o=B_W(3*hiddenSize+1:4*hiddenSize,:);

%Hidden to hidden
B_R=w6;
B_R_i=B_R(1:hiddenSize,:);
B_R_h=B_R(hiddenSize+1:2*hiddenSize,:);
B_R_f=B_R(2*hiddenSize+1:3*hiddenSize,:);
B_R_o=B_R(3*hiddenSize+1:4*hiddenSize,:);

%Biases
B_b=w5;
B_b_i=B_b(1:hiddenSize);
B_b_h=B_b(hiddenSize+1:2*hiddenSize);
B_b_f=B_b(2*hiddenSize+1:3*hiddenSize);
B_b_o=B_b(3*hiddenSize+1:4*hiddenSize);

%%Full Connected Layer Parameters
FC_w=w7;
FC_b=w8;
%clear w*