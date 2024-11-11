clear all;clc;close all ;
    cos_table=zeros(0,360);
    sin_table=zeros(0,360);
    x = 0:360;
for theta = 0:1:360
    fprintf("theta = %d\n",theta);
   [cos_table(theta+1),sin_table(theta+1)]= cordic_rotation(theta);
   fprintf("\n",theta);
end
   
   plot(x,cos_table,x,sin_table,x,(cos((x-180)/360)*65536),x,(sin((x-180)/360)*65536));
       legend('cos_table','sin_table','(cos((x-180)/360)*65536)','(sin((x-180)/360)*65536)');

function [cos_out , sin_out] = cordic_rotation(theta)
    N=16;%迭代次数
    tan_table = (2.^-(0:N-1));
    angle_LUT = atan(tan_table); %建立arctan & angle查找表
    
    An = 1;
    for k = 0 : N - 1
        An = An * (1 / sqrt(1+2^(-2*k)));
    end
    Kn = 1/An;%计算归一化伸缩因子参数 Kn = 1.6476 , 1/Kn = 0.6073
    
    Xn =1/Kn; %相对于x轴上开始旋转
    Xn =39769;
    Yn = 0;
   
    %角度预处理
    if ((theta >= 0)&&(theta <90))
        theta_pre = theta;
         quadrant = 0;
    elseif((theta >= 90)&&(theta <180))
        theta_pre = theta-90;
         quadrant = 1;
    elseif((theta >=180)&&(theta <270))
        theta_pre = theta-180;
         quadrant = 2;
     elseif((theta >=270)&&(theta <360))
        theta_pre = theta-270;
         quadrant = 3;
    else
        theta_pre = 0;
        quadrant = 0;
    end
    
    Zi = (theta_pre / 180*pi)  *2^16 ;%角度转化为弧度
    
    %cordic运算
    for k = 0 : N - 1
        Di = sign(Zi);
        x_temp = Xn;
        Xn = x_temp - Di*Yn*2^(-k);
        Yn = Yn + Di*x_temp*2^(-k);
        Zi = Zi - Di*angle_LUT(k+1) * 2^16;
    end
    if quadrant ==0
        cos_out =  Xn;
        sin_out =  Yn;
    elseif quadrant == 1
        cos_out = -Yn + 1 ;
        sin_out =  Xn ;
    elseif quadrant == 2
        cos_out = -Xn + 1;
        sin_out = -Yn + 1;
    else
        cos_out =  Yn;
        sin_out = -Xn + 1 ;
        
    end
    fprintf("cos （%d°） = %f\n",theta,cos_out);
    fprintf("sin （%d°） = %f\n",theta,sin_out);
end
