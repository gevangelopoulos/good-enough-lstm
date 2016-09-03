h=128;
d=39;
s1=1;
s2=2;
t1=1;
t2=2;

cm=5.5e-6
ca=2.85e-6

M=4*(h*d+h^2)+3*s1*h+2*t1*h+3*h
A=4*(h*d+h^2+2*h)+3*s2*h+2*t2*h+h

m=(4*(h*d+h^2))/M;

results=[];

n=16;
%E=(1-s)*m*M*cm*n^2+(1-m)*M*cm*n^2+A*ca*n;

nref=16;
Eref=M*cm*nref^2+A*ca*nref;
for s=0:0.1:0.9
    E=(1-s)*m*M*cm*n^2+(1-m)*M*cm*n^2+A*ca*n;
    Erel=E/Eref;
    results=[results; s Erel]; 
end

figure('Name', 'Accuracy vs LSTM sparsity');
 h1=axes
 index=100*results(:,1);
 r1=100-results(:,2)*100;
 plot(index,r1,'m--x','LineWidth',5);
 hold on;
 %plot(index,r2,'r--*');
 
 grid on;
 %title('Accuracy of the TIMIT LSTM');
 %axis([0 90  54 101]);
 xlabel('Sparsity') % x-axis10 label
 ylabel('\%') % y-axis label

 %set(h1, 'Xdir', 'reverse')
 %axis([2 16  0 101]);
 
load('../results_sparsity.mat')
 index=results_sparsity_LSTMonly(:,1);
 r1=100-results_sparsity_LSTMonly(:,3);
 r1=(r1/r1(1))*100;
 plot(index,r1,'b--o','LineWidth',5);
 hold on;
%  r2=100-results_sparsity_all(:,3);
%  r2=(r2/r2(1))*100;
%  plot(index,r2,'r--x','LineWidth',5);
%  r3=100-results_sparsity_FConly(:,3);
%  r3=(r3/r3(1))*100;
%  plot(index,r3,'g--*','LineWidth',5);
 grid on;
 %title('Accuracy of the TIMIT LSTM');
 axis([0 90  0 101]);
 legend('Energy Savings', 'LSTM-only pruning relative accuracy','LSTM+FC pruning relative accuracy','FC-only pruning relative accuracy')
 set(gca,'FontSize',30)
 %set(gca,'fontsize',20);
 


