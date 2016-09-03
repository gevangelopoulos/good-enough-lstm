%requires fixed_point_trials
%data is always quantized
set(0,'defaulttextinterpreter','latex')
 load('results_quantization.mat');
 baseline=baseline_80;
 baseline_accuracy=100-baseline;
 %%%%Dynamic FP only quantization
 figure('Name', 'Accuracy - Word Length');
 h1=axes
 index=results_quantize_all_dynamic(:,1);
 r1=100-results_quantize_lstm_dynamic(:,2);
 r1=(r1/baseline_accuracy)*100;
 plot(index,r1,'b--o','LineWidth',5);
 grid on;
 hold on;
 
 r2=100-results_quantize_all_dynamic(:,2);
 r2=(r2/baseline_accuracy)*100;
 plot(index,r2,'r--x','LineWidth',5);
 
 space=2:32
 plot(space, (100)*ones(size(space)),'g-*','LineWidth',5);
 xlabel('Word Length (bits)') % x-axis label
 ylabel('Relative Accuracy \%') % y-axis label 
 %title('Dynamic Fixed-point quantization')
 legend('LSTM only quantization','All layers quantization','32-bit floating point non-quantized')
 %set(gca,'fontsize',20)
 set(h1, 'Xdir', 'reverse')
 axis([2 16  0 100]);
 set(gca,'FontSize',30)
 %%%%%% 

%Naive 
% figure('Name', 'Accuracy - Word Length');
% h1=axes
%  index=results_quantize_all_naive(:,1);
%  r1=100-results_quantize_all_naive(:,2);
%  r1=(r1/r1(1))*100;
%  plot(index,r1,'b--o');
%  grid on;
%  hold on;
%  
%  r2=100-results_quantize_all_dynamic(:,2);
%  r2=(r2/r2(1))*100;
%  plot(index,r2,'r--x');
%  
%  space=2:32
%  plot(space, (100)*ones(size(space)),'g-*');
%  xlabel('Word Length (bits)') % x-axis label
%  ylabel('Relative Accuracy %') % y-axis label
%  title('LSTM+FC quantization')
% 
%  legend('Q.WL/2.WL/2','Dynamic Fixed Point','32-bit floating point')
%  %set(gca,'fontsize',20)
%  set(h1, 'Xdir', 'reverse')
%  axis([2 16  30 100]);
%  %%%%%% 
%  
%  