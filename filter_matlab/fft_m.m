% ����ʱ�䷶Χ
t = 0:0.01:2*pi;
freq1 = 5;
freq2 = 8;

% ����GIF�ļ�
filename = 'sin_wave_animation.gif';
fps = 120;

% ��ʼ���˻�����ĺ�
sum_of_product = zeros(1, length(t));
sum_of_product_sin = zeros(1, length(t));
sum_of_product_cos = zeros(1, length(t));

for i = 1:length(t)
    % ����������ͬƵ�ʵ����Ҳ�
    y1 = cos(freq1 * t);
    y2 = sin((freq2+i/10) * t);
    y3 = cos((freq2+i/10) * t);
    % �����������Ҳ��ĳ˻�

    y_product_sin = y1 .* y2;
    y_product_cos = y1 .* y3;
    % ����˻�����ĺ�
    sum_of_product_sin(i+1) = sum(y_product_sin);
    sum_of_product_cos(i+1) = sum(y_product_cos);
    
    sum_of_product = sqrt(power(sum_of_product_sin, 2) + power(sum_of_product_cos, 2));

    arr = 0:0.1:10;
    subplot(3, 1, 1);
    plot(arr(1:i), sum_of_product_sin(1:i), 'g'); % ֻ���Ƶ�ǰʱ���֮ǰ������
    xlabel('x');
    ylabel('y');
    xlim([0, 10]);
    ylim([-500, 500]);
    title('Re');

    arr = 0:0.1:10;
    subplot(3, 1, 2);
    plot(arr(1:i), sum_of_product_cos(1:i), 'g'); % ֻ���Ƶ�ǰʱ���֮ǰ������
    xlabel('x');
    ylabel('y');
    xlim([0, 10]);
    ylim([-500, 500]);
    title('Im');
    
    arr = 0:0.1:10;
    subplot(3, 1, 3);
    plot(arr(1:i), sum_of_product(1:i), 'g'); % ֻ���Ƶ�ǰʱ���֮ǰ������
    xlabel('x');
    ylabel('y');
    xlim([0, 10]);
    ylim([-500, 500]);
    title('sqrt(power(Re, 2) + power(Im, 2));');

    % ���浱ǰͼ��ΪGIF
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);
    if i == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', 1/fps);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', 1/fps);
    end
    
    if i == 100
        break;
    end

end

