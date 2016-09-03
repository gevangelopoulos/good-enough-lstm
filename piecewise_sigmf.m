function [ y ] = piecewise_sigmf( x,options, mode, xdata,ydata )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    %space=linspace(-10,10,points);
    %values=sigmf(space,options);
    
    space=xdata;
    values=ydata;
    y=interp1(space,values,x,mode,1);
    y(x<-8)=0;
end

