d=39;
h=512;
no=11;
vsize=2;
p=1;
ni=9;
results_vsize=[];
while vsize<=64   
I=no*d+((9-p)*d*h/vsize);
results_vsize=[results_vsize; vsize I];
vsize=vsize*2;
end

results_p=[];
while p<=3
I=no*d+((9-p)*d*h/vsize);
results_p=[results_p; p I];
p=p+1;
end

