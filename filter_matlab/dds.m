close all;clc;clear all;
N = 1024 ;
WIDTH = 8;
y = zeros(N , 1) ;%����100��*1�еľ���

y_integer = zeros(N , 1) ;%����100��*1�еľ���
y_hex = zeros(N , 1) ;%����100��*1�еľ���,ʮ������
for i = 1:1:N %ѭ��1~100���ۼ�1
    x = i ;
    y(i,1) = ceil( (2^WIDTH/2-1)*sin(x*2*pi/N) ) ;%ceilΪ�������뺯���������ΧΪ-127~127�����Ҳ�����
    %y(i,1) = ceil( 127*cos(x*2*pi/N) )  ;%ceilΪ�������뺯���������ΧΪ-127~127�����Ҳ�����
end   

 
fid = fopen('sin_1024_8.coe','wt');    %����һ����Ϊcos_100point.coe���ļ�
%- COE �ļ�ǰ�ø�ʽ
fprintf( fid, 'MEMORY_INITIALIZATION_RADIX = 10;\n');                     
fprintf( fid, 'MEMORY_INITIALIZATION_VECTOR =\n');
%- д����
 
for i = 1:1:N
    if (y(i,1)<0)
       y_integer(i,1)=y(i,1)+2^(WIDTH-1);%�����ò����ʾ
    else
       y_integer(i,1)=y(i,1)+2^(WIDTH-1);%�����Ĳ���Ϊԭ��
    end   
end
plot(y_integer);%��ͼԤ��
%     y_hex= dec2hex(y_integer);%��Ϊdec2hexֻ��ת������������Ƚ�yȡ����
for i = 1:1:N
    if(i == N)
        %���һ����ʱ�����Ϊ�ֺţ�����ʱ��Ϊ����
      %  fprintf(fid,'%d;',y_integer(i,1));  %���16��������
       fprintf(fid,'%d,\n',y(i,1));  %���10��������
    else
      %  fprintf(fid,'%d,\n',y_integer(i,1));  %���16��������
       fprintf(fid,'%d,\n',y(i,1));  %���10��������
    end
end
fclose(fid);%�ر��ļ�