 clear all ;close all;clc;
 tic
tic
 %=============设置系统参数==============%
f1=4;        %设置波形频率
f2=20;
Fs=100;        %设置采样频率
L=1024;         %数据长度
% 计算频率轴
f = Fs*(0:(L/2))/L;
%=============产生输入信号==============%
t=0:1/Fs:(1/Fs)*(L-1);
y1=sin(2*pi*f1*t); 
y2=sin(2*pi*f2*t);
y3=y1+y2;
subplot(311);
plot(t,y1,'red');
subplot(312);
plot(t,y2,'blue');
subplot(313);
plot(t,y3,'green');
figure;
title("DFT");

figure;
%dft 计算过程 先计算有限长序列中每个因子与对应的旋转因子的乘积
for i = 0 : L - 1
   for j = 0 : L - 1
      y((i+1),(j+1)) = (complex(cos(2*pi*i*j/L) , -sin(2*pi*i*j/L) ));%这里的旋转因子也就是不同频率的序列
       %将输入信号的序列 与 不同频率的序列分别相乘，所以这里嵌套了两层循环，实际上就是Y3(1) * Y(1)(1) Y3(1)*Y(2)(1) ...
       %Y3(i)代表输入信号序列的第几个值 
       %Y（j）(i) 其中J就代表将2*PI分成N分每一份的频率 例如 (2*PI / 1024 * J)这就是Y（j）的含义 后面的i 则代表Y（J）序列中的第几个值
      X((i+1),(j+1)) = y3(j+1) .* (complex(cos(2*pi*i*j/L) , -sin(2*pi*i*j/L) ));
   end
end

%只取小数点后五位
Xreal =roundn( real(X),-5);
Ximage=roundn( imag(X),-5);
%然后对求出来的乘积进行求和
Xrealsum=sum(Xreal,2);
Xrealsum= roundn( Xrealsum,-5);
Ximagsum=sum(Ximage,2);
Ximagsum= roundn( Ximagsum,-5);
X_SUM=complex(Xrealsum,Ximagsum);
%matlab自带的fft函数，用来做比较
x_fft = fft(y3);

%功率
power = abs(x_fft).^2/L; 

n=0:1:L-1;
%实部
subplot(221);
stem(n,Xrealsum(n+1));
grid on;
%虚部
subplot(222);
stem(n,Ximagsum(n+1));
grid on;
%取模的值
subplot(223);
stem(n,abs(X_SUM(n+1)));
grid on;
%功率谱
subplot(224);
power_fft=abs(X_SUM(n+1)).^2/L;
stem(f,power_fft(1:L/2+1));
grid on;
%matlab自带的fft的功率谱
figure;
stem(f, power(1:L/2+1));
grid on;
%这里打印出对应的频率
for i = 1 : L/2+1
   if power_fft(i) > 1
       fprintf("feqz = %d\n",f(i));
   end
end
 elapsed_time = toc;
disp(['Elapsed time: ', num2str(elapsed_time), ' seconds.']);



