%��Ƶ֡����ȡ
% NumberOfFrames �C ��Ƶ����֡�� 
obj = VideoReader('../picture/��߸.mp4');%������Ƶλ��
numFrames = obj.NumberOfFrames;% ֡������
%frame = read(obj)%��ȡ����Ƶ���������֡
% frame = read(obj,index)%��ȡ����Ƶ������ƶ�֡
% frame = read(obj, 1);         % first frame only ��ȡ��һ֡
% frame = read(obj, [1 10]);    % first 10 frames ��ȡǰ10֡
% frame = read(obj, Inf);       % last frame only ��ȡ���һ֡
% frame = read(obj, [50 Inf]);  % frame 50 thru end ��ȡ��50֮֡��
 for k =1:10000% ��ȡ1000֡
  frame = read(obj,k);%��ȡ�ڼ�֡
     % imshow(frame);%��ʾ֡
      imwrite(frame,strcat('../xx/',num2str(k),'.jpg'),'jpg');% ����֡
      %%%frameΪ�������ĳһ֡ 
      %%%strcat('E:\experiment\BPNN_edge\moreFrameImg\allPic\frameImg\1.jpg')Ϊ����Ŀ¼
      %%%'jpg'Ϊ�����ʽ
 end
