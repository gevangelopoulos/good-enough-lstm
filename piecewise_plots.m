set(0, 'defaultTextInterpreter', 'latex');
 load('results_piecewise.mat');
 baseline=baseline_80;
 baseline_accuracy=100-baseline;
 %%%%Sigmoid
 figure('Name', 'Accuracy - sigmoid LUT of size (N)');
 h1=axes
 index=results_sigmf_unrestricted(:,1);
 r1=100-results_sigmf_unrestricted(:,2);
 r1=(r1/baseline_accuracy)*100;
 plot(index,r1,'b--o','LineWidth',5);
 grid on;
 hold on;
 
 r2=100-results_sigmf_even(:,2);
 r2=(r2/baseline_accuracy)*100;
 plot(index,r2,'r--x','LineWidth',5);
 
 r3=100-results_sigmf_pow2(:,2);
 r3=(r3/baseline_accuracy)*100;
 plot(index,r3,'k--s','LineWidth',5);
 
 space=2:32;
 plot(space, (100)*ones(size(space)),'g-*','LineWidth',5);
 xlabel('Breakpoints') % x-axis label
 ylabel('Relative Accuracy \%') % y-axis label 
 %title('LUT sigmoid with N breakpoints')
 legend('Unrestricted spacing','Even Spacing','Power-of-2 spacing','Ideal Sigmoid')
 %set(gca,'fontsize',20)
 set(h1, 'Xdir', 'reverse')
 axis([2 8  80 105]);
  set(gca,'FontSize',30)
 
 %%%%%% 
% 

 %%%%Tansig
 figure('Name', 'Accuracy - Tansig LUT of size (N)');
 h1=axes
 index=results_tansig_unrestricted(:,1);
 r1=100-results_tansig_unrestricted(:,2);
 r1=(r1/baseline_accuracy)*100;
 plot(index,r1,'b--o','LineWidth',5);
 grid on;
 hold on;
 
 r2=100-results_tansig_even(:,2);
 r2=(r2/baseline_accuracy)*100;
 plot(index,r2,'r--x','LineWidth',5);
 
 r3=100-results_tansig_pow2(:,2);
 r3=(r3/baseline_accuracy)*100;
 plot(index,r3,'k--s','LineWidth',5);
 
 space=2:64;
 plot(space, (100)*ones(size(space)),'g-*','LineWidth',5);
 xlabel('Breakpoints') % x-axis label
 ylabel('Relative Accuracy \%') % y-axis label 
 %title('LUT tansig with N breakpoints')
 legend('Unrestricted spacing','Even Spacing','Power-of-2 spacing','Ideal Hyperbolic Tangent')
 %set(gca,'fontsize',20)
 set(h1, 'Xdir', 'reverse')
 axis([2 8  50 105]);
  set(gca,'FontSize',30)
 
 %%%%%% 
%  