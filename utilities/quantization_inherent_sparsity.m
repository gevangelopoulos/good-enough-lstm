% startup;
% totalParameterNumber=numel(w1)+numel(w2)+numel(w3)+numel(w4)...
%     +numel(w5)+numel(w6)+numel(w7)+numel(w8);
% results=[];
% results_per_matrix=[]
% for WL=32:-1:2
%     load parameters.mat
%     [w1 w2 w3 w4 w5 w6 w7 w8 feats] = quantize_weights(WL,w1,w2,w3,w4,w5,w6,w7,w8, feats);
%     w1=w1+0.5;
%     w2=w2+0.5;
%     w3=w3+0.5;
%     w4=w4+0.5;
%     w5=w5+0.5;
%     w6=w6+0.5;
%     w7=w7+0.5;
%     w8=w8+0.5;
%     reshape_matrices;
%     
%     sF_W_i(WL)=nnz(F_W_i)/prod(size(F_W_i));
%     sF_W_h(WL)=nnz(F_W_h)/prod(size(F_W_h));
%     sF_W_f(WL)=nnz(F_W_f)/prod(size(F_W_f));
%     sF_W_o(WL)=nnz(F_W_o)/prod(size(F_W_o));
%     sF_R_i(WL)=nnz(F_R_i)/prod(size(F_R_i));
%     sF_R_h(WL)=nnz(F_R_h)/prod(size(F_R_h));
%     sF_R_f(WL)=nnz(F_R_f)/prod(size(F_R_f));
%     sF_R_o(WL)=nnz(F_R_o)/prod(size(F_R_o));
%     sF_b_i(WL)=nnz(F_b_i)/prod(size(F_b_i));
%     sF_b_h(WL)=nnz(F_b_h)/prod(size(F_b_h));
%     sF_b_f(WL)=nnz(F_b_f)/prod(size(F_b_f));
%     sF_b_o(WL)=nnz(F_b_o)/prod(size(F_b_o));
%     
%     sB_W_i(WL)=nnz(B_W_i)/prod(size(B_W_i));
%     sB_W_h(WL)=nnz(B_W_h)/prod(size(B_W_h));
%     sB_W_f(WL)=nnz(B_W_f)/prod(size(B_W_f));
%     sB_W_o(WL)=nnz(B_W_o)/prod(size(B_W_o));
%     sB_R_i(WL)=nnz(B_R_i)/prod(size(B_R_i));
%     sB_R_h(WL)=nnz(B_R_h)/prod(size(B_R_h));
%     sB_R_f(WL)=nnz(B_R_f)/prod(size(B_R_f));
%     sB_R_o(WL)=nnz(B_R_o)/prod(size(B_R_o));
%     sB_b_i(WL)=nnz(B_b_i)/prod(size(B_b_i));
%     sB_b_h(WL)=nnz(B_b_h)/prod(size(B_b_h));
%     sB_b_f(WL)=nnz(B_b_f)/prod(size(B_b_f));
%     sB_b_o(WL)=nnz(B_b_o)/prod(size(B_b_o));
%     
%     sFC_w(WL)=nnz(FC_w)/prod(size(FC_w));
%     sFC_b(WL)=nnz(FC_b)/prod(size(FC_b));
%     
%      total_sparsity=(nnz(w1)+nnz(w2)+nnz(w3)+nnz(w4)+nnz(w5)+nnz(w6)...
%         +nnz(w7)+nnz(w8))...
%         /(prod(size(w1))+prod(size(w2))+prod(size(w3))+prod(size(w4))+...
%         prod(size(w5))+prod(size(w6))+prod(size(w7))+prod(size(w8)));
%     results= [results; WL total_sparsity]
%     results_per_matrix=[results_per_matrix; [sF_W_i(WL) sF_W_h(WL) sF_W_f(WL)...
%         sF_W_o(WL) sF_R_i(WL) sF_R_h(WL) ...
%     sF_R_f(WL) sF_R_o(WL) sF_b_i(WL) sF_b_h(WL) sF_b_f(WL) sF_b_o(WL) ...
% sB_W_i(WL) sB_W_h(WL) sB_W_f(WL) sB_W_o(WL) sB_R_i(WL) sB_R_h(WL) ...
% sB_R_f(WL) sB_R_o(WL) sB_b_i(WL) sB_b_h(WL) sB_b_f(WL) sB_b_o(WL) ...
% sFC_w(WL) sFC_b(WL)]] 
% end

 figure('Name', 'Inherent Sparsity - Word Length');
 h1=axes
 index=results(:,1);
 r1=results(:,2);
 r1=r1*100;
 plot(index,r1,'b-*','LineWidth',5);
 grid on;
 hold on;
 
 plot(results(:,1),100*results_per_matrix)
 
 xlabel('Word Length (bits)') % x-axis label
 ylabel('Inherent data sparsity %') % y-axis label 
 title('')
 legend('Overall')
 %set(gca,'fontsize',20)
 set(h1, 'Xdir', 'reverse')
 axis([2 16  0 100]);
 %%%%%% 