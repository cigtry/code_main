clc;clear all;
IMG_gray=imread('../picture/Scart.jpg');
IMG_gray = rgb2gray(IMG_gray);
imwrite(IMG_gray,'../picture/Scart.bmp','bmp');
% kun = imread('../picture/Scart.bmp');
% ikun = imresize(kun , [1280,720]);
% ikun =imread('../picture/ikun.jpg');
%imshow(ikun);
%将图片的数据转换成仿真文件所需的数据格式
% h = size(ikun,1);         % 读取图像高度
% w = size(ikun,2);         % 读取图像宽度
% bar = waitbar(0,'data generating >>>>');
% fid = fopen('../data/ikun.dat','wt');
% fprintf(fid,'#ifndef __PLATFORM_H_ \n');
% fprintf(fid,'#define __PLATFORM_H_ \n');
% fprintf(fid,'const unsigned int gImage_picture[] = { \n');
% for row = 1:h
%     r = lower(dec2hex(ikun(row,:,1),2));
%     g = lower(dec2hex(ikun(row,:,2),2));
%     b = lower(dec2hex(ikun(row,:,3),2));
%     str_data_tmp = [];
%     for col = 1:w
%         str_data_tmp = [str_data_tmp,'0x',r(col*2-1:col*2),', ','0x',g(col*2-1:col*2),', ','0x',b(col*2-1:col*2),', '];
%     end
%     str_data_tmp = [str_data_tmp,10];
%     fprintf(fid,'%s',str_data_tmp);
%     waitbar(row/h);
% end
% fprintf(fid,'} \n');
% fprintf(fid,'#endif \n');
% fclose(fid);
% close(bar);
