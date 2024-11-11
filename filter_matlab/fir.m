%****************************************************************************************
%                             FIR��ͨ�˲������
%***************************************************************************************
fs=1000;                %���ò���Ƶ�� 1k
N=1024;                %��������      
n=0:N-1;
t=0:1/fs:1-1/fs;          %ʱ������
f=n*fs/N;               %Ƶ������

Signal_Original=sin(2*pi*50*t);      %�ź�50Hz���Ҳ�
Signal_Noise=sin(2*pi*200*t);      %����200Hz���Ҳ�

Mix_Signal=Signal_Original+Signal_Noise;  %���ź�Signal_Original��Signal_Original�ϳ�һ���źŽ��в���               
subplot(221);
plot(t, Mix_Signal);   %�����ź�Mix_Signal�Ĳ���                                                 
xlabel('ʱ��');
ylabel('��ֵ');
title('ԭʼ�ź�');
grid on;
  
subplot(222);
y=fft(Mix_Signal, N);     %���ź� Mix_Signal��FFT   
plot(f,abs(y));
xlabel('Ƶ��/Hz');
ylabel('���');
title('ԭʼ�ź�FFT');
grid on;

b = fir1(30, 0.25);       %30��FIR��ͨ�˲�������ֹƵ��125Hz
%y2= filter(b, 1, x);
y2=filtfilt(b,1,x);           %����FIR�˲�����õ����ź�
Ps=sum(Signal_Original.^2);          %�źŵ��ܹ���
Pu=sum((y2-Signal_Original).^2);     %ʣ�������Ĺ���
SNR=10*log10(Ps/Pu);               %�����

y3=fft(y2, N);            %����FIR�˲�����õ����ź���FFT
subplot(223);                               
plot(f,abs(y3));
xlabel('Ƶ��/Hz');
ylabel('���');
title('�˲����ź�FFT');
grid on;

[H,F]=freqz(b,1,512);        %ͨ��fir1��Ƶ�FIRϵͳ��Ƶ����Ӧ
subplot(224);
plot(F/pi,abs(H));           %���Ʒ�Ƶ��Ӧ
xlabel('��һ��Ƶ��');        
title(['Order=',int2str(30),'    SNR=',num2str(SNR)]);
grid on;
