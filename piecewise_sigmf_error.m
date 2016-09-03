%Piecewise sigmf
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
results=[];
spacing='unrestricted'; %the LUT will be implemented with uneven spacing
for i=2:step:high
    LUTdata=LUTimplement_sigmf(i,spacing);
    xdata=LUTdata(:,1);
    ydata=LUTdata(:,2);
    
    err=abs(sigmf(space, [1 0])-piecewise_sigmf(space, [1 0], 'linear', xdata, ydata));
    results=[results; err'];
end
results_sigmf_unrestricted=results;

results=[];
spacing='even'; %the LUT will be implemented with even spacing
for i=low:step:high
    LUTdata=LUTimplement_sigmf(i,spacing);
    xdata=LUTdata(:,1);
    ydata=LUTdata(:,2);
    
    r=forward_pass_piecewise_sigmf(mode,xdata,ydata);
    results=[results; i r];
end
results_sigmf_even=results;

results=[];
spacing='pow2'; %the LUT will be implemented with pow2 spacing
for i=low:step:high
    LUTdata=LUTimplement_sigmf(i,spacing);
    xdata=LUTdata(:,1);
    ydata=LUTdata(:,2);
    
    r=forward_pass_piecewise_sigmf(mode,xdata,ydata);
    results=[results; i r];
end
results_sigmf_pow2=results;

full_filename=strcat(filename,'.mat')
save(full_filename,'results_sigmf_unrestricted','results_sigmf_even', 'results_sigmf_pow2');