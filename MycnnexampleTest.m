%{
neg = 112; %没有目标的图像
pos = 112; %有目标的图像
[test_x, test_y] = GDInit('D:\!zju\！Graduation design\image\s\small_48\', [neg,pos]); 
cnn.layers = {
struct('type', 'i') %input layer
struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
};
opts.alpha = 1;
opts.batchsize = 56; %将所有数据打乱后 分size(train_x,3) / opts.batchsize批放入cnn（每个数据训练一次）
opts.numepochs = 1000; %上述操作做opts.numepochs次（每个数据训练10次）
%}
%% 载入数据
load Mycnnexample_0
%test_x = ;
%test_y = ;

%% 测试网络
t = tic;
fprintf('\n现在测试网络...');
[er, bad, hh, aa] = cnntest(cnn, test_x, test_y);
fprintf(' 完成 测试耗时：');
toc(t);

%% 画误差图
%%plot mean squared error
figure; plot(cnn.rL);

