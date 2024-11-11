% 加载BMP图片
bmp_img = imread('../picture/kun.bmp'); % 请替换为你的实际BMP文件路径

% 将BMP转换为灰度图像
gray_img = rgb2gray(bmp_img);

% 转换为0到1之间的双精度浮点数
 double_data = uint8(gray_img);

% 将双精度数组转换为16进制字符串
hex_data = dec2hex(double_data(:)); % 行向量转列向量

% 打印或保存结果
%disp(hex_data); % 在命令窗口显示
save hex_file.dat  double_data; % 保存到文本文件