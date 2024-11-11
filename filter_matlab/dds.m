close all;clc;clear all;
N = 1024 ;
WIDTH = 8;
y = zeros(N , 1) ;%生成100行*1列的矩阵

y_integer = zeros(N , 1) ;%生成100行*1列的矩阵
y_hex = zeros(N , 1) ;%生成100行*1列的矩阵,十六进制
for i = 1:1:N %循环1~100，累加1
    x = i ;
    y(i,1) = ceil( (2^WIDTH/2-1)*sin(x*2*pi/N) ) ;%ceil为四舍五入函数，输出范围为-127~127的正弦波数据
    %y(i,1) = ceil( 127*cos(x*2*pi/N) )  ;%ceil为四舍五入函数，输出范围为-127~127的余弦波数据
end   

 
fid = fopen('sin_1024_8.coe','wt');    %创建一个名为cos_100point.coe的文件
%- COE 文件前置格式
fprintf( fid, 'MEMORY_INITIALIZATION_RADIX = 10;\n');                     
fprintf( fid, 'MEMORY_INITIALIZATION_VECTOR =\n');
%- 写数据
 
for i = 1:1:N
    if (y(i,1)<0)
       y_integer(i,1)=y(i,1)+2^(WIDTH-1);%负数用补码表示
    else
       y_integer(i,1)=y(i,1)+2^(WIDTH-1);%正数的补码为原码
    end   
end
plot(y_integer);%画图预览
%     y_hex= dec2hex(y_integer);%因为dec2hex只能转换正数，因此先将y取补码
for i = 1:1:N
    if(i == N)
        %最后一个点时，标点为分号，其余时候为逗号
      %  fprintf(fid,'%d;',y_integer(i,1));  %输出16进制数据
       fprintf(fid,'%d,\n',y(i,1));  %输出10进制数据
    else
      %  fprintf(fid,'%d,\n',y_integer(i,1));  %输出16进制数据
       fprintf(fid,'%d,\n',y(i,1));  %输出10进制数据
    end
end
fclose(fid);%关闭文件