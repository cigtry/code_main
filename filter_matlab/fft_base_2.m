
clear all ;close all;clc;
tic
 %=============设置系统参数==============%
f1=4;        %设置波形频率
f2=20;
Fs=100;        %设置采样频率
N=32;         %数据长度
% 计算频率轴
f = Fs*(0:(N/2))/N;
%=============产生输入信号==============%
t=0:1/Fs:(1/Fs)*(N-1);
y1=sin(2*pi*f1*t); 
y2=sin(2*pi*f2*t);
% x=y1+y2;
x=1:1:N;
subplot(311);
plot(t,y1,'red');
subplot(312);
plot(t,y2,'blue');
subplot(313);
plot(t,x,'green');
figure;

%上面利用固定的32点的示例完成了32点的FFT计算，下面考虑通用的写法来实现
%先将输入序列进行倒序
 result(1,:) =reverseIndex(x);
%计算蝶形因子
 Wn(1) = 1; %Wn的0次方为1
 for j=2:N
 	Wn(j) = floor(exp(-i * (2*pi/N))^(j-1) * 2^7); %这里的i为虚数单位
 end
 
for i = 1 : N/2
    fprintf("Wn[%d] = %d\n ",i,floor(real(Wn(i)) * 2^7) );
end

for i = 1 : log2(N) %总共需要计算log2(N)层
    k = 2^i;
    for j = 1 : N / k
        for ij = 1 : k/2 
%打印调试信息看是否符合蝶形图%
%             s1=i;
%             s2=k;
%             s3=j;
%             s4= i + 1;
%             s5 = (k*(j-1)+ij);
%             s6 = (k*(j-1)+ij+k/2);
%             s7 = Wn((ij-1) * (N / k )+ 1);
%             fprintf("i=%d ,k = %d ,j =%d ,result(%d,%d)=result(%d,%d) + wn(%d)*result(%d,%d)\n",s1,s2,s3,s4,s5,s1,s5,s7,s1,s6);
%             fprintf("i=%d ,k = %d ,j =%d ,result(%d,%d)=result(%d,%d) - wn(%d)*result(%d,%d)\n",s1,s2,s3,s4,s6,s1,s5,s7,s1,s6);
            result(i+1,(k*(j-1)+ij) )    = result(i,(k*(j-1)+ij) ) + Wn((ij-1) * (N / k )+ 1) * result(i,(k*(j-1)+ij+k/2) ); 
            result(i+1,(k*(j-1)+ij+k/2)) = result(i,(k*(j-1)+ij) ) - Wn((ij-1) * (N / k )+ 1) * result(i,(k*(j-1)+ij+k/2) ); 
        end
    end
%     fprintf("=====================\n");
end

x_fft = fft(x);

 subplot(211);
   stem(t,abs(x_fft));
   title("FFT MATLAB");
 subplot(212);
   stem(t,abs(result(log2(N)+1 , : )));
   title("FFT");
 figure;
 power = abs(x_fft).^2/N; 
 power_FFT_2 = abs(result(log2(N)+1 , : )).^2/N; 
 subplot(211);
   stem(f,power(1:N/2+1));
   title("FFT MATLAB POWER");
 subplot(212);
   stem(f,power_FFT_2(1:N/2+1));
   title("FFT POWER");

elapsed_time = toc;
disp(['Elapsed time: ', num2str(elapsed_time), ' seconds.']);

function yk = reverseIndex(xk) %倒序
	len = length(xk);
	yk = zeros(1,len);
	for i=1:len 
		indexBin = fliplr(dec2bin(i-1,log2(len)));
		yk(i) = xk(bin2dec(indexBin) + 1);
    end
end
