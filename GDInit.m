function [ test_x, test_y ] = GDInit( File_path, label_list )    
%% function [ test_x, test_y ] = GDInit( File_path, label_list )
%   test_x�����ݲ���[:, :, num(label_num)]
%   test_y�Ǳ��[length(label_list), num(label_num)]
%   File_path���ǵü�\
%   label_list = [4 5 6]�������Ϊ1��������4�� ���Ϊ2������5�� ���Ϊ3��������6��
%   ���sum(label_list)С��Ŀ¼�µ�����bmpͼƬ������ôֻ���ȡǰsum(label_list)��ͼƬ

    file_path = File_path;
    file_type = 'bmp';
    img_path_list = dir(strcat(file_path, ['*.', file_type]));
    img_num = length(img_path_list);
    %assert(sum(label_list)==img_num, ['img_num in ' File_path ' is ' num2str(img_num) ' But sum(label_list) is ' num2str(sum(label_list)) ' NOT equal! ']);
    if sum(label_list)~=img_num
        disp(['sum(label_list)~=img_num']);
    end
    if img_num > 0
        I = [];
        n = 1;
    	for j = 1:sum(label_list) %img_num
    		image_name = img_path_list(j).name;
    		image = imread(strcat(file_path,image_name));
    		% fprintf('%d / %d GDInit... \n', j,img_num); 
            I(:,:,n) = image;
            n = n+1;
        end
        test_x = double(I)/256;
        test_y = zeros([sum(label_list) length(label_list)]);
        n = 1;
        for q = 1:length(label_list)
            for w = 1:label_list(q)
                test_y(n,q) = 1;
                n = n+1;
            end
        end
        test_y = test_y';
    end
    fprintf([' %d ', file_type ], img_num); 
end

