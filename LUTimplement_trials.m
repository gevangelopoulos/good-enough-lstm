N=[4 8];
spacing={'pow2','even','unrestricted'};
for i=1:3
    for j=1:2
    LUTimplement(N(j),char(spacing(i)));
    end
end
    