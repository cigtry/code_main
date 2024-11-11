 clear all ;close all;clc;
 tic
tic
 %=============����ϵͳ����==============%
f1=4;        %���ò���Ƶ��
f2=20;
Fs=100;        %���ò���Ƶ��
L=1024;         %���ݳ���
% ����Ƶ����
f = Fs*(0:(L/2))/L;
%=============���������ź�==============%
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
%dft ������� �ȼ������޳�������ÿ���������Ӧ����ת���ӵĳ˻�
for i = 0 : L - 1
   for j = 0 : L - 1
      y((i+1),(j+1)) = (complex(cos(2*pi*i*j/L) , -sin(2*pi*i*j/L) ));%�������ת����Ҳ���ǲ�ͬƵ�ʵ�����
       %�������źŵ����� �� ��ͬƵ�ʵ����зֱ���ˣ���������Ƕ��������ѭ����ʵ���Ͼ���Y3(1) * Y(1)(1) Y3(1)*Y(2)(1) ...
       %Y3(i)���������ź����еĵڼ���ֵ 
       %Y��j��(i) ����J�ʹ���2*PI�ֳ�N��ÿһ�ݵ�Ƶ�� ���� (2*PI / 1024 * J)�����Y��j���ĺ��� �����i �����Y��J�������еĵڼ���ֵ
      X((i+1),(j+1)) = y3(j+1) .* (complex(cos(2*pi*i*j/L) , -sin(2*pi*i*j/L) ));
   end
end

%ֻȡС�������λ
Xreal =roundn( real(X),-5);
Ximage=roundn( imag(X),-5);
%Ȼ���������ĳ˻��������
Xrealsum=sum(Xreal,2);
Xrealsum= roundn( Xrealsum,-5);
Ximagsum=sum(Ximage,2);
Ximagsum= roundn( Ximagsum,-5);
X_SUM=complex(Xrealsum,Ximagsum);
%matlab�Դ���fft�������������Ƚ�
x_fft = fft(y3);

%����
power = abs(x_fft).^2/L; 

n=0:1:L-1;
%ʵ��
subplot(221);
stem(n,Xrealsum(n+1));
grid on;
%�鲿
subplot(222);
stem(n,Ximagsum(n+1));
grid on;
%ȡģ��ֵ
subplot(223);
stem(n,abs(X_SUM(n+1)));
grid on;
%������
subplot(224);
power_fft=abs(X_SUM(n+1)).^2/L;
stem(f,power_fft(1:L/2+1));
grid on;
%matlab�Դ���fft�Ĺ�����
figure;
stem(f, power(1:L/2+1));
grid on;
%�����ӡ����Ӧ��Ƶ��
for i = 1 : L/2+1
   if power_fft(i) > 1
       fprintf("feqz = %d\n",f(i));
   end
end
 elapsed_time = toc;
disp(['Elapsed time: ', num2str(elapsed_time), ' seconds.']);



