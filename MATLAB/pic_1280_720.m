function pic_1280_720(fram_jpg,fram_bmp,fram_data,gen_data)
%将任意图片转换成FPGA适用的1280*720大小的BMP图片并保存
fram = imread(fram_jpg);
fram = rgb2gray(fram);
fram = uint8(fram);
imwrite(fram,fram_bmp,'bmp');
fram = imresize(fram , [1280,720]);
figure;
imshow(fram);
    if gen_data == 1
        generate_data(fram,fram_data);
        fprintf("generate_data done\r\n");
    else
        fprintf("pic2bmp ok\r\n");
    end

end

