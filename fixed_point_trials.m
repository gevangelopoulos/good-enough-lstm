%File logging
filename=datestr(datetime);
filename=strrep(filename,' ','_');
filename=strcat('matlab_experiment_',filename);
full_filename=strcat(filename,'.log');
FILE=fopen(full_filename,'a');
results=[];
%  for WL=32:-1:2
%     WL
%     r=forward_pass_fixed_naive(FILE, WL,ceil(WL/2));
%     
%     results=[results; [WL r ]]
%  end
%  full_filename=strcat(filename,'.mat')
%  save(full_filename,'results');
 

%====Better version with dynamic quantization
for WL=32:-1:2
   WL
   r=forward_pass_fixed_dynamic(FILE, WL);
   
   results=[results; [WL r ]]
end
full_filename=strcat(filename,'.mat')
save(full_filename,'results');
