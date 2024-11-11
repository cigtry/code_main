 % 将数据恢复成图像
% 将数据恢复成图像
function display_data(fileid)     
fid=fopen(fileid,'r');                     %打开数据文件
formatSpec = '%x';
sizea = [1280 720];
bmp=fscanf(fid,formatSpec,sizea);             %读取文件数据
fclose(fid);                                %关闭文件
bmp = uint8(bmp);
bmp = imresize(bmp , [720,1280]);
figure;imshow(bmp);
end