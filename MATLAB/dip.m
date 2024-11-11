clc;clear all;close all;
nezha1 = imread('../picture/ikun.jpg');
%nezha1 = rgb2gray(nezha1);
nezha1 = uint8(nezha1);
nezha1 = imresize(nezha1 , [600,800]);
imwrite(nezha1,'../picture/ikun1.bmp','bmp');

%imshow(nezha1);
%generate_data0(nezha1);

% figure;
% nezha2 = imread('../picture/nezha2.jpg');
% nezha2 = rgb2gray(nezha2);
% nezha2 = uint8(nezha2);
% imwrite(nezha2,'../picture/nezha2.bmp','bmp');
% nezha2 = imresize(nezha2 , [1280,720]);
% imshow(nezha2);
% generate_data1(nezha2);
% ikun_avg_fialter = imfilter(ikun,fspecial('average',3),'replicate');%均值滤波
% ikun_avg_fialter = imfilter(ikun,fspecial('gaussian',[5,5],3),'replicate');%高斯滤波
% subplot(132);
% imshow(ikun_avg_fialter);

%generate_data(ikun);
% fileid='../data/ikun_avg_fialter.dat';  
%  fileid='../data/med_filter.dat';  
%  fileid='../data/average_filter.dat';  
% fileid='../data/gauss_filter.dat';  
% fileid='../data/bilateral_filter.dat';  
fileid='../data/med_filter.dat';  
% fileid='../data/region_bin_ikun.dat';  
display_data1(fileid);
% figure;
% fileid1='../data/bin_erosion.dat';  
% display_data(fileid1);
% figure;
% fileid2='../data/bin_dilation.dat';  
% display_data(fileid2);

% figure;
% fileid3='../data/fram_diff1.dat';  
% jpg1='../picture/fram_diff1.jpg'; 
% display_data(fileid3,jpg1);
% 
% figure;
% jpg2='../picture/box_diff1.jpg'; 
% fileid4='../data/gauss_filter.dat';  
% display_data(fileid4,jpg2);

% 将数据恢复成图像
function display_data1(fileid)     
fid=fopen(fileid,'r');                     %打开数据文件
formatSpec = '%x';
sizea = [1280 720];
bmp=fscanf(fid,formatSpec,sizea);             %读取文件数据
fclose(fid);                                %关闭文件
bmp = uint8(bmp);
figure;imshow(bmp);
end

function generate_data0(ikun)
% 生成灰度图数据
bar = waitbar(0,'data generating >>>>');
fid = fopen('../data/Scart.dat','wt');
h = size(ikun , 1);
w = size(ikun , 2);
for row = 1:w
    str_data_tmp = [];
    for col = 1:h
        data = lower(dec2hex(ikun(col,row),2));
        str_data_tmp = [str_data_tmp,data,' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h);
end
fclose(fid);
close(bar);
end

function generate_data1(ikun)
% 生成灰度图数据
bar = waitbar(0,'data generating >>>>');
fid = fopen('../data/Scart.dat','wt');
h = size(ikun , 1);
w = size(ikun , 2);
for row = 1:w
    str_data_tmp = [];
    for col = 1:h
        data = lower(dec2hex(ikun(col,row),2));
        str_data_tmp = [str_data_tmp,data,' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h);
end
fclose(fid);
close(bar);
end


