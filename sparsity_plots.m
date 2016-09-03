 %Sparsity plots. Needs sparsity_trials to be executed.
 load results_sparsity.mat
 figure('Name', 'Accuracy vs LSTM sparsity');
 index=results_sparsity_LSTMonly(:,1);
 r1=100-results_sparsity_LSTMonly(:,3);
 r1=(r1/r1(1))*100;
 plot(index,r1,'b--o','LineWidth',5);
 hold on;
 r2=100-results_sparsity_all(:,3);
 r2=(r2/r2(1))*100;
 plot(index,r2,'r--x','LineWidth',5);
 r3=100-results_sparsity_FConly(:,3);
 r3=(r3/r3(1))*100;
 plot(index,r3,'g--*','LineWidth',5);
 grid on;
 %title('Accuracy of the TIMIT LSTM');
 axis([0 90  54 101]);
 xlabel('Pruned Connections \%') % x-axis10 label
 ylabel('Relative Accuracy \%') % y-axis label
 legend('LSTM-only pruning','LSTM+FC pruning','FC-only pruning')
 set(gca,'FontSize',30)
 %set(gca,'fontsize',20);