function generate_data(ikun,dat)
% 生成灰度图数据
bar = waitbar(0,'data generating >>>>');
fid = fopen(dat,'wt');
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
