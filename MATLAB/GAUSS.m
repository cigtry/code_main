clear all;close all;clc;
ikun = imread('../picture/ikun.bmp');
subplot(121);imshow(ikun);
img2 = bilateral_filter_gray_int(ikun,3,3,0.1);

subplot(122);imshow(img2);
function gauss5x5%���ɸ�˹ģ��
sigma = 3;
G1= zeros(5,5);%����5*5��С�ĸ�˹ģ��
for i = -2:2
    for j =-2 : 2
       G1(i+3,j+3)=exp(-(i^2+j^2)/(2*sigma^2)); 
    end
end
%��һ��5*5��˹ģ��
temp = sum(sum(G1));
G2 = G1/temp;
%���㻯
G3 = floor(G2 * 1024);
end

function B=bilateral_filter_gray_int(I,n,sigma_d,sigma_r)%
dim = size(I);
w = floor(n/2);

%�����˹ģ��
G1 = zeros(n,n);
for i = -w : w
    for j =-w : w
        G1(i+w+1,j+w+1) = exp(-(i^2 + j^2)/(2*sigma_d^2));
    end
end
%��һ����˹ģ��
   temp = sum(G1(:));
   G2 = G1/temp;
%���㻯��˹ģ��
G3 =floor(G2 * 1024);

%�������ƶ�ָ��*1024���
%H=zeros(1:256);
for i=0:255
   H(i+1) = exp(-(i/255)^2 / (2*sigma_r^2)); 
end
H=floor(H*1024);

I=double(I);
%����n*n˫���˲�ģ��+�˲����
h = waitbar(0,'speed of bilateral filter process..');
B=zeros(dim);
for i=1 : dim(1)
    for j=1 : dim(2)
         if(i<w+1 || i>dim(1)-w || j<w+1 || j>dim(2)-w)
            B(i,j) = I(i,j);    %��Ե����ȡԭֵ
         else
             A = I(i-w:i+w, j-w:j+w);
%              H =  exp( -(I(i,j)-A).^2/(2*sigma_r^2)  ) ;
             F1 = reshape(H(abs(A-I(i,j))+1), n, n);    %�������ƶ�Ȩ��(10bit)
             F2 = F1 * G3;                                       %����˫��Ȩ�أ�20bit��
             F3=floor(F2*1024/sum(F2(:)));                        %��һ��˫���˲�Ȩ�أ�����1024��
             B(i,j) = sum(F3(:) .*A(:))/1024;                %�����õ������ۼӵĽ������С1024��
          end
    end
     waitbar(i/dim(1));
end
close(h);   % Close waitbar.
I = uint8(I);
B = uint8(B);
end



