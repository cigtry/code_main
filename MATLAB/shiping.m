%视频帧的提取
% NumberOfFrames – 视频的总帧数 
obj = VideoReader('../picture/哪吒.mp4');%输入视频位置
numFrames = obj.NumberOfFrames;% 帧的总数
%frame = read(obj)%获取该视频对象的所有帧
% frame = read(obj,index)%获取该视频对象的制定帧
% frame = read(obj, 1);         % first frame only 获取第一帧
% frame = read(obj, [1 10]);    % first 10 frames 获取前10帧
% frame = read(obj, Inf);       % last frame only 获取最后一帧
% frame = read(obj, [50 Inf]);  % frame 50 thru end 获取第50帧之后
 for k =1:10000% 读取1000帧
  frame = read(obj,k);%读取第几帧
     % imshow(frame);%显示帧
      imwrite(frame,strcat('../xx/',num2str(k),'.jpg'),'jpg');% 保存帧
      %%%frame为待保存的某一帧 
      %%%strcat('E:\experiment\BPNN_edge\moreFrameImg\allPic\frameImg\1.jpg')为保存目录
      %%%'jpg'为保存格式
 end
