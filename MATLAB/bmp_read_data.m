% ����BMPͼƬ
bmp_img = imread('../picture/kun.bmp'); % ���滻Ϊ���ʵ��BMP�ļ�·��

% ��BMPת��Ϊ�Ҷ�ͼ��
gray_img = rgb2gray(bmp_img);

% ת��Ϊ0��1֮���˫���ȸ�����
 double_data = uint8(gray_img);

% ��˫��������ת��Ϊ16�����ַ���
hex_data = dec2hex(double_data(:)); % ������ת������

% ��ӡ�򱣴���
%disp(hex_data); % ���������ʾ
save hex_file.dat  double_data; % ���浽�ı��ļ�