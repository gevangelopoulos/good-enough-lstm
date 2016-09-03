function [ y ] = piecewise_tansig( x, mode, xdata,ydata )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    space=xdata;
    values=ydata;
    y=interp1(space,values,x,mode,1);    
    y(x<-8)=-1;
end

