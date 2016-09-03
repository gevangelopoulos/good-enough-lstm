h=128;
d=39;
s1=1;
s2=1;
t1=1;
t2=1;

cm=5.5e-6
ca=2.85e-6

M=4*(h*d+h^2)+3*s1*h+2*t1*h+3*h
A=4*(h*d+h^2+2*h)+3*s2*h+2*t2*h+h
results=[];


nref=16;
Eref=M*cm*nref^2+A*ca*nref;
for n=2:16
    E=M*cm*n^2+A*ca*n;
    Erel=E/Eref;
    results=[results; n Erel]; 
end
 n=5;
 figure('Name', 'Accuracy vs LSTM sparsity');
 h1=axes
 index=results(:,1);
 r1=100-results(:,2)*100;
 plot(index,r1,'m--o','LineWidth',5);
 hold on;
 load('../results_quantization.mat');
 index=results_quantize_all_dynamic(:,1);
 r2=100-results_quantize_lstm_dynamic(:,2);
 baseline_accuracy=100-baseline_80;
 r2=(r2/baseline_accuracy)*100;
 plot(index,r2,'r--*','LineWidth',5);
 
 r3=100-results_quantize_all_dynamic(:,2);
 r3=(r3/baseline_accuracy)*100;
 plot(index,r3,'b--x','LineWidth',5);
 set(gca,'FontSize',30)
 
 grid on;
 %title('Accuracy of the TIMIT LSTM');
 %axis([0 90  54 101]);
 xlabel('Word length') % x-axis10 label
 ylabel('\%') % y-axis label
 legend('Energy Savings', 'Accuracy (LSTM-only Quantized)','Accuracy (LSTM-only Quantized)' )

 set(h1, 'Xdir', 'reverse')
 axis([2 16  0 101]);

%  xmarkers = [6 7 8]
%  ymarkers = [r1(6-1) r1(7-1) r1(8-1)];
 
%  plot(xmarkers,ymarkers,'r*')
 



