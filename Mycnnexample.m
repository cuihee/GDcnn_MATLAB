clc;clear;
%% 读入数据
t = tic;
fprintf('\n现在读入数据...');

neg = 112; %没有目标的图像
pos = 112; %有目标的图像
[test_x, test_y] = GDInit('D:\!zju\！Graduation design\image\s\small_48\', [neg,pos]);

temp_train_list = [1:14, neg+1:14]; % 这里选择训练数据 14个无 14个有
train_x = test_x(:,:, temp_train_list); 
train_y = test_y(:, temp_train_list);

temp_test_list = [15:112, neg+15:112]; % 这里选择测试数据，剔除训练数据
test_x = test_x(:,:, temp_test_list); 
test_y = test_y(:, temp_test_list);

time_input = toc(t);
fprintf(' 完成 耗时：%.2f s', time_input);

%% 初始化网络结构
t = tic;
rng('default');
cnn.layers = {
struct('type', 'i') %input layer
struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
};
fprintf(['\n现在初始化网络结构...', cnn.layers{1,1}.type, ' ', cnn.layers{2,1}.type, num2str(cnn.layers{2,1}.kernelsize),'-',num2str(cnn.layers{2,1}.outputmaps), ' ', cnn.layers{3,1}.type, num2str(cnn.layers{3,1}.scale), ' ', cnn.layers{4,1}.type, num2str(cnn.layers{4,1}.kernelsize), '-',num2str(cnn.layers{4,1}.outputmaps), ' ', cnn.layers{5,1}.type, num2str(cnn.layers{5,1}.scale), ' ']);
cnn = cnnsetup(cnn, train_x, train_y);
time_build = toc(t);
fprintf(' 完成 耗时：%.2f s', time_build);

%% 训练
t = tic;
fprintf('\n现在训练网络... ');
opts.alpha = 1;
opts.batchsize = 14; %将所有数据打乱后 分size(train_x,3) / opts.batchsize批放入cnn（每个数据训练一次）
opts.numepochs = 3000; %上述操作做opts.numepochs次（每个数据训练opts.numepochs次）
opts.error_limit = 0.001; %指定误差在区间 (opts.batchsize/(pos+neg), 0) 是有意义的
fprintf('小批数=%d 大批数epoch=%d \n', size(train_x,3) / opts.batchsize, opts.numepochs);
cnn = cnntrain(cnn, train_x, train_y, opts);
time_train = toc(t);
fprintf(' 完成 训练耗时：%.2f min', time_train/60);

%%　测试
t = tic;
fprintf('\n现在测试网络...');
[error_rate, error_list, prediction_label_list, right_label_list] = cnntest(cnn, test_x, test_y);
time_test = toc(t);
fprintf(' 完成 测试耗时：%.2f s', time_test);
fprintf('\n【总耗时】：%.2f min', (time_test+time_train+time_build+time_input)/60);

%% 画误差图
%%plot mean squared error
figure; plot(cnn.rL);
