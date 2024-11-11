close all;clc;clear all;
N = 1024 ;
y = zeros(N , 1) ;
for i = 1:1:N 
    x = i ;
    y(i,1) = ceil( 127*sin(x*2*pi/N) ) + 127 ;
    %y(i,1) = ceil( 127*cos(x*2*pi/N) ) + 127 ;
end   
plot(y);
fid = fopen('./sin.coe','wt');
fprintf(fid,'memory_initialization_radix =10;\n');
fprintf(fid,'memory_initialization_vector=\n');
fprintf(fid,'%d,\n',y);
fclose(fid);