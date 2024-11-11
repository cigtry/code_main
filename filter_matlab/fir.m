%****************************************************************************************
%                             FIR低通滤波器设计
%***************************************************************************************
fs=1000;                %设置采样频率 1k
N=1024;                %采样点数      
n=0:N-1;
t=0:1/fs:1-1/fs;          %时间序列
f=n*fs/N;               %频率序列

Signal_Original=sin(2*pi*50*t);      %信号50Hz正弦波
Signal_Noise=sin(2*pi*200*t);      %噪声200Hz正弦波

Mix_Signal=Signal_Original+Signal_Noise;  %将信号Signal_Original和Signal_Original合成一个信号进行采样               
subplot(221);
plot(t, Mix_Signal);   %绘制信号Mix_Signal的波形                                                 
xlabel('时间');
ylabel('幅值');
title('原始信号');
grid on;
  
subplot(222);
y=fft(Mix_Signal, N);     %对信号 Mix_Signal做FFT   
plot(f,abs(y));
xlabel('频率/Hz');
ylabel('振幅');
title('原始信号FFT');
grid on;

b = fir1(30, 0.25);       %30阶FIR低通滤波器，截止频率125Hz
%y2= filter(b, 1, x);
y2=filtfilt(b,1,x);           %经过FIR滤波器后得到的信号
Ps=sum(Signal_Original.^2);          %信号的总功率
Pu=sum((y2-Signal_Original).^2);     %剩余噪声的功率
SNR=10*log10(Ps/Pu);               %信噪比

y3=fft(y2, N);            %经过FIR滤波器后得到的信号做FFT
subplot(223);                               
plot(f,abs(y3));
xlabel('频率/Hz');
ylabel('振幅');
title('滤波后信号FFT');
grid on;

[H,F]=freqz(b,1,512);        %通过fir1设计的FIR系统的频率响应
subplot(224);
plot(F/pi,abs(H));           %绘制幅频响应
xlabel('归一化频率');        
title(['Order=',int2str(30),'    SNR=',num2str(SNR)]);
grid on;
