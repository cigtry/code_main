 clear all ;close all;clc;
Fs=8;        %设置采样频率
    L=8;         %数据长度
    t=0:1/Fs:(1/Fs)*(L-1);
    x=cos(2*pi*3*t ); 
    y1 =cos(2*pi*0*t)  -sin(2*pi*0*t)*j;
    y2 =cos(2*pi*1*t)  -sin(2*pi*1*t)*j;
    y3 =cos(2*pi*2*t)  -sin(2*pi*2*t)*j;
    y4 =cos(2*pi*3*t)  -sin(2*pi*3*t)*j;
    y5 =cos(2*pi*4*t)  -sin(2*pi*4*t)*j;
    y6 =cos(2*pi*5*t)  -sin(2*pi*5*t)*j;
    y7 =cos(2*pi*6*t)  -sin(2*pi*6*t)*j;
    y8 =cos(2*pi*7*t)  -sin(2*pi*7*t)*j;

    x1 = x.*y1;
    x2 = x.*y2;
    x3 = x.*y3;
    x4 = x.*y4;
    x5 = x.*y5;
    x6 = x.*y6;
    x7 = x.*y7;
    x8 = x.*y8;
    
    x_all=[x1;x2;x3;x4;x5;x6;x7;x8];
    y_all=[y1;y2;y3;y4;y5;y6;y7;y8];
    x_sum0=roundn(sum(x1),-5);
    x_sum1=roundn(sum(x2),-5);
    x_sum2=roundn(sum(x3),-5);
    x_sum3=roundn(sum(x4),-5);
    x_sum4=roundn(sum(x5),-5);
    x_sum5=roundn(sum(x6),-5);
    x_sum6=roundn(sum(x7),-5);
    x_sum7=roundn(sum(x8),-5);
    
    
 %16点FFT过程%