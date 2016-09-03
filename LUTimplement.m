function [results] = LUTimplement(N, mode)
%func='sigmf(x,[1 0])';
func='sigmf(x)';
xmin=-8;
xmax=8;
xdt=sfix(16);
xscale=2^-12;
ydt=sfix(16);
yscale=2^-14;
rndmeth='Floor'
nptsmax=N;
spacing=mode;
[xdata,ydata,errworst] = ...
fixpt_look1_func_approx(func,...
 xmin,xmax,xdt,xscale,ydt,yscale,rndmeth,[],nptsmax,spacing);

results=[xdata, ydata];
%figure
%fixpt_look1_func_plot(xdata,ydata,func,xmin,xmax,...
% xdt,xscale,ydt,yscale,rndmeth);
