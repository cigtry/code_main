 clear all ;close all;clc;
 %================================%
N = 32;
Fs = 10;        %设置采样频率
f1 = 0.1;        %设置波形频率
t = 0:1/Fs:(1/Fs)*(N-1);
%产生32点的序列MTLAB
 %x=sin(2*pi*f1/Fs*t); 
 x = 1:1:N;

data = x;
 
%计算旋转因子
BF_factor_L1 = linspace(0,N/32-1,N/32);
BF_factor_L1 = exp(-1j*2*pi/2.*BF_factor_L1); % 蝶形因子 * 32767

BF_factor_L2 = linspace(0,N/16-1,N/16);
BF_factor_L2 = exp(-1j*2*pi/4.*BF_factor_L2); % 蝶形因子 * 32767

BF_factor_L3 = linspace(0,N/8-1,N/8);
BF_factor_L3 = exp(-1j*2*pi/8.*BF_factor_L3); % 蝶形因子 * 32767

BF_factor_L4 = linspace(0,N/4-1,N/4);
BF_factor_L4 = exp(-1j*2*pi/16.*BF_factor_L4); % 蝶形因子 * 32767

BF_factor_L5 = linspace(0,N/2-1,N/2);
BF_factor_L5 = exp(-1j*2*pi/32.*BF_factor_L5); % 蝶形因子 * 32767

%按照DFT的流程开始
%这里就是在倒序    
%倒数第一级
   E0 = x(:,1:2:end);%偶数序列
   O0 = x(:,2:2:end);%奇数序列
%倒数第二级
    E10 = E0(:,1:2:end);
    O10 = E0(:,2:2:end);
    E11 = O0(:,1:2:end);
    O11 = O0(:,2:2:end);
%倒数第三级
    E20 = E10(:,1:2:end);
    O20 = E10(:,2:2:end);
    E21 = O10(:,1:2:end);
    O21 = O10(:,2:2:end);
    E22 = E11(:,1:2:end);
    O22 = E11(:,2:2:end);
    E23 = O11(:,1:2:end);
    O23 = O11(:,2:2:end);
%倒数第四级
    E30 = E20(:,1:2:end);
    O30 = E20(:,2:2:end);
    E31 = O20(:,1:2:end);
    O31 = O20(:,2:2:end);
    E32 = E21(:,1:2:end);
    O32 = E21(:,2:2:end);
    E33 = O21(:,1:2:end);
    O33 = O21(:,2:2:end);
    E34 = E22(:,1:2:end);
    O34 = E22(:,2:2:end);
    E35 = O22(:,1:2:end);
    O35 = O22(:,2:2:end);
    E36 = E23(:,1:2:end);
    O36 = E23(:,2:2:end);
    E37 = O23(:,1:2:end);
    O37 = O23(:,2:2:end);
    %32位的数据倒序完成后合并成新的序列
XK = [ E30, O30, E31, O31, E32, O32, E33, O33, E34, O34, E35, O35, E36, O36, E37, O37];


for i =1: N/2
    XK1(2*(i-1) +1 ) = XK(2*(i-1)+1)+BF_factor_L1(1)*XK(2*(i-1)+2);
    XK1(2*(i-1) +2 ) = XK(2*(i-1)+1)-BF_factor_L1(1)*XK(2*(i-1)+2);
end

for i =1: N/4
    XK2(4*(i-1) +1 ) = XK1(4*(i-1)+1)+BF_factor_L2(1)*XK1(4*(i-1)+3);
    XK2(4*(i-1) +2 ) = XK1(4*(i-1)+2)+BF_factor_L2(2)*XK1(4*(i-1)+4);
    XK2(4*(i-1) +3 ) = XK1(4*(i-1)+1)-BF_factor_L2(1)*XK1(4*(i-1)+3);
    XK2(4*(i-1) +4 ) = XK1(4*(i-1)+2)-BF_factor_L2(2)*XK1(4*(i-1)+4);
end

for i =1: N/8
    XK3(8*(i-1) +1 ) = XK2(8*(i-1)+1)+BF_factor_L3(1)*XK2(8*(i-1)+5);
    XK3(8*(i-1) +2 ) = XK2(8*(i-1)+2)+BF_factor_L3(2)*XK2(8*(i-1)+6);
    XK3(8*(i-1) +3 ) = XK2(8*(i-1)+3)+BF_factor_L3(3)*XK2(8*(i-1)+7);
    XK3(8*(i-1) +4 ) = XK2(8*(i-1)+4)+BF_factor_L3(4)*XK2(8*(i-1)+8);
    XK3(8*(i-1) +5 ) = XK2(8*(i-1)+1)-BF_factor_L3(1)*XK2(8*(i-1)+5);
    XK3(8*(i-1) +6 ) = XK2(8*(i-1)+2)-BF_factor_L3(2)*XK2(8*(i-1)+6);
    XK3(8*(i-1) +7 ) = XK2(8*(i-1)+3)-BF_factor_L3(3)*XK2(8*(i-1)+7);
    XK3(8*(i-1) +8 ) = XK2(8*(i-1)+4)-BF_factor_L3(4)*XK2(8*(i-1)+8);
end

for i =1: N/16
    XK4(16*(i-1) +1 )  = XK3(16*(i-1)+1 )+BF_factor_L4(1)*XK3(16*(i-1)+9);
    XK4(16*(i-1) +2 )  = XK3(16*(i-1)+2 )+BF_factor_L4(2)*XK3(16*(i-1)+10);
    XK4(16*(i-1) +3 )  = XK3(16*(i-1)+3 )+BF_factor_L4(3)*XK3(16*(i-1)+11);
    XK4(16*(i-1) +4 )  = XK3(16*(i-1)+4 )+BF_factor_L4(4)*XK3(16*(i-1)+12);
    XK4(16*(i-1) +5 )  = XK3(16*(i-1)+5 )+BF_factor_L4(5)*XK3(16*(i-1)+13);
    XK4(16*(i-1) +6 )  = XK3(16*(i-1)+6)+BF_factor_L4(6)*XK3(16*(i-1)+14);
    XK4(16*(i-1) +7 )  = XK3(16*(i-1)+7)+BF_factor_L4(7)*XK3(16*(i-1)+15);
    XK4(16*(i-1) +8 )  = XK3(16*(i-1)+8)+BF_factor_L4(8)*XK3(16*(i-1)+16);
    XK4(16*(i-1) +9 )  = XK3(16*(i-1)+1 )-BF_factor_L4(1)*XK3(16*(i-1)+9);
    XK4(16*(i-1) +10 ) = XK3(16*(i-1)+2 )-BF_factor_L4(2)*XK3(16*(i-1)+10);
    XK4(16*(i-1) +11 ) = XK3(16*(i-1)+3 )-BF_factor_L4(3)*XK3(16*(i-1)+11);
    XK4(16*(i-1) +12 ) = XK3(16*(i-1)+4 )-BF_factor_L4(4)*XK3(16*(i-1)+12);
    XK4(16*(i-1) +13 ) = XK3(16*(i-1)+5 )-BF_factor_L4(5)*XK3(16*(i-1)+13);
    XK4(16*(i-1) +14 ) = XK3(16*(i-1)+6 )-BF_factor_L4(6)*XK3(16*(i-1)+14);
    XK4(16*(i-1) +15 ) = XK3(16*(i-1)+7 )-BF_factor_L4(7)*XK3(16*(i-1)+15);
    XK4(16*(i-1) +16 ) = XK3(16*(i-1)+8 )-BF_factor_L4(8)*XK3(16*(i-1)+16);
end

for i =1: N/32
    XK5(32*(i-1) +1 )  = XK4(32*(i-1)+1 )+BF_factor_L5( 1)*XK4(32*(i-1)+17 );
    XK5(32*(i-1) +2 )  = XK4(32*(i-1)+2 )+BF_factor_L5( 2)*XK4(32*(i-1)+18 );
    XK5(32*(i-1) +3 )  = XK4(32*(i-1)+3 )+BF_factor_L5( 3)*XK4(32*(i-1)+19 );
    XK5(32*(i-1) +4 )  = XK4(32*(i-1)+4 )+BF_factor_L5( 4)*XK4(32*(i-1)+20);
    XK5(32*(i-1) +5 )  = XK4(32*(i-1)+5 )+BF_factor_L5( 5)*XK4(32*(i-1)+21);
    XK5(32*(i-1) +6 )  = XK4(32*(i-1)+6 )+BF_factor_L5( 6)*XK4(32*(i-1)+22);
    XK5(32*(i-1) +7 )  = XK4(32*(i-1)+7 )+BF_factor_L5( 7)*XK4(32*(i-1)+23);
    XK5(32*(i-1) +8 )  = XK4(32*(i-1)+8 )+BF_factor_L5( 8)*XK4(32*(i-1)+24);
    XK5(32*(i-1) +9 )  = XK4(32*(i-1)+9 )+BF_factor_L5( 9)*XK4(32*(i-1)+25);
    XK5(32*(i-1) +10 ) = XK4(32*(i-1)+10)+BF_factor_L5(10)*XK4(32*(i-1)+26);
    XK5(32*(i-1) +11 ) = XK4(32*(i-1)+11)+BF_factor_L5(11)*XK4(32*(i-1)+27);
    XK5(32*(i-1) +12 ) = XK4(32*(i-1)+12)+BF_factor_L5(12)*XK4(32*(i-1)+28);
    XK5(32*(i-1) +13 ) = XK4(32*(i-1)+13)+BF_factor_L5(13)*XK4(32*(i-1)+29);
    XK5(32*(i-1) +14 ) = XK4(32*(i-1)+14)+BF_factor_L5(14)*XK4(32*(i-1)+30);
    XK5(32*(i-1) +15 ) = XK4(32*(i-1)+15)+BF_factor_L5(15)*XK4(32*(i-1)+31);
    XK5(32*(i-1) +16 ) = XK4(32*(i-1)+16)+BF_factor_L5(16)*XK4(32*(i-1)+32);
    XK5(32*(i-1) +17)  = XK4(32*(i-1)+1 )-BF_factor_L5( 1)*XK4(32*(i-1)+17);
    XK5(32*(i-1) +18)  = XK4(32*(i-1)+2 )-BF_factor_L5( 2)*XK4(32*(i-1)+18);
    XK5(32*(i-1) +19)  = XK4(32*(i-1)+3 )-BF_factor_L5( 3)*XK4(32*(i-1)+19);
    XK5(32*(i-1) +20)  = XK4(32*(i-1)+4 )-BF_factor_L5( 4)*XK4(32*(i-1)+20);
    XK5(32*(i-1) +21)  = XK4(32*(i-1)+5 )-BF_factor_L5( 5)*XK4(32*(i-1)+21);
    XK5(32*(i-1) +22)  = XK4(32*(i-1)+6 )-BF_factor_L5( 6)*XK4(32*(i-1)+22);
    XK5(32*(i-1) +23)  = XK4(32*(i-1)+7 )-BF_factor_L5( 7)*XK4(32*(i-1)+23);
    XK5(32*(i-1) +24)  = XK4(32*(i-1)+8 )-BF_factor_L5( 8)*XK4(32*(i-1)+24);
    XK5(32*(i-1) +25)  = XK4(32*(i-1)+9 )-BF_factor_L5( 9)*XK4(32*(i-1)+25);
    XK5(32*(i-1) +26 ) = XK4(32*(i-1)+10)-BF_factor_L5(10)*XK4(32*(i-1)+26);
    XK5(32*(i-1) +27 ) = XK4(32*(i-1)+11)-BF_factor_L5(11)*XK4(32*(i-1)+27);
    XK5(32*(i-1) +28 ) = XK4(32*(i-1)+12)-BF_factor_L5(12)*XK4(32*(i-1)+28);
    XK5(32*(i-1) +29 ) = XK4(32*(i-1)+13)-BF_factor_L5(13)*XK4(32*(i-1)+29);
    XK5(32*(i-1) +30 ) = XK4(32*(i-1)+14)-BF_factor_L5(14)*XK4(32*(i-1)+30);
    XK5(32*(i-1) +31 ) = XK4(32*(i-1)+15)-BF_factor_L5(15)*XK4(32*(i-1)+31);
    XK5(32*(i-1) +32 ) = XK4(32*(i-1)+16)-BF_factor_L5(16)*XK4(32*(i-1)+32);
end

%网上示例参考
% Level_0
[result_L0(1) ,result_L0(2)] = butterfly(data(1) ,data(17),BF_factor_L1(1));
[result_L0(3) ,result_L0(4)] = butterfly(data(9) ,data(25),BF_factor_L1(1));
[result_L0(5) ,result_L0(6)] = butterfly(data(5) ,data(21),BF_factor_L1(1));
[result_L0(7) ,result_L0(8)] = butterfly(data(13),data(29),BF_factor_L1(1));
[result_L0(9) ,result_L0(10)]= butterfly(data(3) ,data(19),BF_factor_L1(1));
[result_L0(11),result_L0(12)]= butterfly(data(11),data(27),BF_factor_L1(1));
[result_L0(13),result_L0(14)]= butterfly(data(7) ,data(23),BF_factor_L1(1));
[result_L0(15),result_L0(16)]= butterfly(data(15),data(31),BF_factor_L1(1));
[result_L0(17),result_L0(18)]= butterfly(data(2) ,data(18),BF_factor_L1(1));
[result_L0(19),result_L0(20)]= butterfly(data(10),data(26),BF_factor_L1(1));
[result_L0(21),result_L0(22)]= butterfly(data(6) ,data(22),BF_factor_L1(1));
[result_L0(23),result_L0(24)]= butterfly(data(14),data(30),BF_factor_L1(1));
[result_L0(25),result_L0(26)]= butterfly(data(4) ,data(20),BF_factor_L1(1));
[result_L0(27),result_L0(28)]= butterfly(data(12),data(28),BF_factor_L1(1));
[result_L0(29),result_L0(30)]= butterfly(data(8) ,data(24),BF_factor_L1(1));
[result_L0(31),result_L0(32)]= butterfly(data(16),data(32),BF_factor_L1(1));

% Level_1
[result_L1(1) ,result_L1(3)] = butterfly(result_L0(1) ,result_L0(3) ,BF_factor_L2(1));
[result_L1(2) ,result_L1(4)] = butterfly(result_L0(2) ,result_L0(4) ,BF_factor_L2(2));
[result_L1(5) ,result_L1(7)] = butterfly(result_L0(5) ,result_L0(7) ,BF_factor_L2(1));
[result_L1(6) ,result_L1(8)] = butterfly(result_L0(6) ,result_L0(8) ,BF_factor_L2(2));
[result_L1(9) ,result_L1(11)]= butterfly(result_L0(9) ,result_L0(11),BF_factor_L2(1));
[result_L1(10),result_L1(12)]= butterfly(result_L0(10),result_L0(12),BF_factor_L2(2));
[result_L1(13),result_L1(15)]= butterfly(result_L0(13),result_L0(15),BF_factor_L2(1));
[result_L1(14),result_L1(16)]= butterfly(result_L0(14),result_L0(16),BF_factor_L2(2));
[result_L1(17),result_L1(19)]= butterfly(result_L0(17),result_L0(19),BF_factor_L2(1));
[result_L1(18),result_L1(20)]= butterfly(result_L0(18),result_L0(20),BF_factor_L2(2));
[result_L1(21),result_L1(23)]= butterfly(result_L0(21),result_L0(23),BF_factor_L2(1));
[result_L1(22),result_L1(24)]= butterfly(result_L0(22),result_L0(24),BF_factor_L2(2));
[result_L1(25),result_L1(27)]= butterfly(result_L0(25),result_L0(27),BF_factor_L2(1));
[result_L1(26),result_L1(28)]= butterfly(result_L0(26),result_L0(28),BF_factor_L2(2));
[result_L1(29),result_L1(31)]= butterfly(result_L0(29),result_L0(31),BF_factor_L2(1));
[result_L1(30),result_L1(32)]= butterfly(result_L0(30),result_L0(32),BF_factor_L2(2));

% Level_2
[result_L2(1) ,result_L2(5)] = butterfly(result_L1(1) ,result_L1(5) ,BF_factor_L3(1));
[result_L2(2) ,result_L2(6)] = butterfly(result_L1(2) ,result_L1(6) ,BF_factor_L3(2));
[result_L2(3) ,result_L2(7)] = butterfly(result_L1(3) ,result_L1(7) ,BF_factor_L3(3));
[result_L2(4) ,result_L2(8)] = butterfly(result_L1(4) ,result_L1(8) ,BF_factor_L3(4));
[result_L2(9) ,result_L2(13)]= butterfly(result_L1(9) ,result_L1(13),BF_factor_L3(1));
[result_L2(10),result_L2(14)]= butterfly(result_L1(10),result_L1(14),BF_factor_L3(2));
[result_L2(11),result_L2(15)]= butterfly(result_L1(11),result_L1(15),BF_factor_L3(3));
[result_L2(12),result_L2(16)]= butterfly(result_L1(12),result_L1(16),BF_factor_L3(4));
[result_L2(17),result_L2(21)]= butterfly(result_L1(17),result_L1(21),BF_factor_L3(1));
[result_L2(18),result_L2(22)]= butterfly(result_L1(18),result_L1(22),BF_factor_L3(2));
[result_L2(19),result_L2(23)]= butterfly(result_L1(19),result_L1(23),BF_factor_L3(3));
[result_L2(20),result_L2(24)]= butterfly(result_L1(20),result_L1(24),BF_factor_L3(4));
[result_L2(25),result_L2(29)]= butterfly(result_L1(25),result_L1(29),BF_factor_L3(1));
[result_L2(26),result_L2(30)]= butterfly(result_L1(26),result_L1(30),BF_factor_L3(2));
[result_L2(27),result_L2(31)]= butterfly(result_L1(27),result_L1(31),BF_factor_L3(3));
[result_L2(28),result_L2(32)]= butterfly(result_L1(28),result_L1(32),BF_factor_L3(4));

% Level_3
[result_L3(1) ,result_L3(9)] = butterfly(result_L2(1) ,result_L2(9) ,BF_factor_L4(1));
[result_L3(2) ,result_L3(10)]= butterfly(result_L2(2) ,result_L2(10),BF_factor_L4(2));
[result_L3(3) ,result_L3(11)]= butterfly(result_L2(3) ,result_L2(11),BF_factor_L4(3));
[result_L3(4) ,result_L3(12)]= butterfly(result_L2(4) ,result_L2(12),BF_factor_L4(4));
[result_L3(5) ,result_L3(13)]= butterfly(result_L2(5) ,result_L2(13),BF_factor_L4(5));
[result_L3(6) ,result_L3(14)]= butterfly(result_L2(6) ,result_L2(14),BF_factor_L4(6));
[result_L3(7) ,result_L3(15)]= butterfly(result_L2(7) ,result_L2(15),BF_factor_L4(7));
[result_L3(8) ,result_L3(16)]= butterfly(result_L2(8) ,result_L2(16),BF_factor_L4(8));
[result_L3(17),result_L3(25)]= butterfly(result_L2(17),result_L2(25),BF_factor_L4(1));
[result_L3(18),result_L3(26)]= butterfly(result_L2(18),result_L2(26),BF_factor_L4(2));
[result_L3(19),result_L3(27)]= butterfly(result_L2(19),result_L2(27),BF_factor_L4(3));
[result_L3(20),result_L3(28)]= butterfly(result_L2(20),result_L2(28),BF_factor_L4(4));
[result_L3(21),result_L3(29)]= butterfly(result_L2(21),result_L2(29),BF_factor_L4(5));
[result_L3(22),result_L3(30)]= butterfly(result_L2(22),result_L2(30),BF_factor_L4(6));
[result_L3(23),result_L3(31)]= butterfly(result_L2(23),result_L2(31),BF_factor_L4(7));
[result_L3(24),result_L3(32)]= butterfly(result_L2(24),result_L2(32),BF_factor_L4(8));

% Level_4
[result_L4(1) ,result_L4(17)]= butterfly(result_L3(1) ,result_L3(17),BF_factor_L5(1));
[result_L4(2) ,result_L4(18)]= butterfly(result_L3(2) ,result_L3(18),BF_factor_L5(2));
[result_L4(3) ,result_L4(19)]= butterfly(result_L3(3) ,result_L3(19),BF_factor_L5(3));
[result_L4(4) ,result_L4(20)]= butterfly(result_L3(4) ,result_L3(20),BF_factor_L5(4));
[result_L4(5) ,result_L4(21)]= butterfly(result_L3(5) ,result_L3(21),BF_factor_L5(5));
[result_L4(6) ,result_L4(22)]= butterfly(result_L3(6) ,result_L3(22),BF_factor_L5(6));
[result_L4(7) ,result_L4(23)]= butterfly(result_L3(7) ,result_L3(23),BF_factor_L5(7));
[result_L4(8) ,result_L4(24)]= butterfly(result_L3(8) ,result_L3(24),BF_factor_L5(8));
[result_L4(9) ,result_L4(25)]= butterfly(result_L3(9) ,result_L3(25),BF_factor_L5(9));
[result_L4(10),result_L4(26)]= butterfly(result_L3(10),result_L3(26),BF_factor_L5(10));
[result_L4(11),result_L4(27)]= butterfly(result_L3(11),result_L3(27),BF_factor_L5(11));
[result_L4(12),result_L4(28)]= butterfly(result_L3(12),result_L3(28),BF_factor_L5(12));
[result_L4(13),result_L4(29)]= butterfly(result_L3(13),result_L3(29),BF_factor_L5(13));
[result_L4(14),result_L4(30)]= butterfly(result_L3(14),result_L3(30),BF_factor_L5(14));
[result_L4(15),result_L4(31)]= butterfly(result_L3(15),result_L3(31),BF_factor_L5(15));
[result_L4(16),result_L4(32)]= butterfly(result_L3(16),result_L3(32),BF_factor_L5(16));

 x_fft=fft(x);
 subplot(311);
 stem(t,abs(x_fft));
 subplot(312);
 stem(t,abs(result_L4));
  subplot(313);
 stem(t,abs(XK5));
 
 function [outputArg0,outputArg1] = butterfly(arg0,arg1,butterfly_factor)
%BUTTERFLY 蝶形运算
%   此处显示详细说明
    outputArg0 = arg0 + arg1 * butterfly_factor;
    outputArg1 = arg0 - arg1 * butterfly_factor;
 end
   