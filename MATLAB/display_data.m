 % �����ݻָ���ͼ��
% �����ݻָ���ͼ��
function display_data(fileid)     
fid=fopen(fileid,'r');                     %�������ļ�
formatSpec = '%x';
sizea = [1280 720];
bmp=fscanf(fid,formatSpec,sizea);             %��ȡ�ļ�����
fclose(fid);                                %�ر��ļ�
bmp = uint8(bmp);
bmp = imresize(bmp , [720,1280]);
figure;imshow(bmp);
end