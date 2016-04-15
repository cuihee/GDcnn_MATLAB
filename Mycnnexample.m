clc;clear;
%% 读入数据
t = tic;
fprintf('\n现在读入数据...');


neg = 112; %没有目标的图像
pos = 112; %有目标的图像
[test_x, test_y] = GDInit('D:\!zju\！Graduation design\image\s\small_48\', [neg,pos]); 

%{
neg = 19;
pos = 21;
[test_x, test_y] = GDInit('D:\!zju\！Graduation design\image\cut250\', [neg,pos]);
%}
train_x = test_x(:,:, [1:100, neg+1:neg+100]); % 这里选择全部数据都训练，一般可以留一部分用作测试
train_y = test_y(:, [1:100, neg+1:neg+100]);
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
opts.batchsize = 40; %将所有数据打乱后 分size(train_x,3) / opts.batchsize批放入cnn（每个数据训练一次）
opts.numepochs = 100; %上述操作做opts.numepochs次（每个数据训练100次）
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
