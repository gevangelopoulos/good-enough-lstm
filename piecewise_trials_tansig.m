%Piecewise tansig
%File logging
filename=datestr(datetime);
filename=strrep(filename,' ','_');
filename=strcat('matlab_experiment_',filename);
full_filename=strcat(filename,'.log');
FILE=fopen(full_filename,'a');

low=2; %the lowest number of breakpoints
high=8; %the highest number of breakpoints
step=2; %the step of the trial
mode='linear'; %interpolations is going to be linear

i=low;
results=[];
spacing='unrestricted'; %the LUT will be implemented with uneven spacing
while i<=high
    LUTdata=LUTimplement_tansig(i,spacing);
    xdata=LUTdata(:,1);
    ydata=LUTdata(:,2);
    
    r=forward_pass_piecewise_tansig(mode,xdata,ydata);
    results=[results; i r];
    i=i+2;
end
results_tansig_unrestricted=results;

i=low;
results=[];
spacing='even'; %the LUT will be implemented with even spacing
while i<=high
    LUTdata=LUTimplement_tansig(i,spacing);
    xdata=LUTdata(:,1);
    ydata=LUTdata(:,2);
    
    r=forward_pass_piecewise_tansig(mode,xdata,ydata);
    results=[results; i r];
    i=i+2;
end
results_tansig_even=results;

i=low;
results=[];
spacing='pow2'; %the LUT will be implemented with pow2 spacing
while i<=high
    LUTdata=LUTimplement_tansig(i,spacing);
    xdata=LUTdata(:,1);
    ydata=LUTdata(:,2);
    
    r=forward_pass_piecewise_tansig(mode,xdata,ydata);
    results=[results; i r];
    i=i+2;
end
results_tansig_pow2=results;

full_filename=strcat(filename,'.mat')
save(full_filename,'results_tansig_unrestricted','results_tansig_even', 'results_tansig_pow2');