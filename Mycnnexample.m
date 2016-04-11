%{
neg = 152;
pos = 248;
[test_x, test_y] = GDInit('D:\!zju\！Graduation design\image\cut250ex\', [neg,pos]);
%152个没有目标的图像 648个有目标的图像
%}
% 请确认 标号和数据是否对应
neg = 19;
pos = 81;
[test_x, test_y] = GDInit('D:\!zju\！Graduation design\image\cut250\', [neg,pos]);

train_x = test_x(:,:, [1:neg, neg+1:neg+pos]);
train_y = test_y(:, [1:neg, neg+1:neg+pos]);

rng('default');
cnn.layers = {
struct('type', 'i') %input layer
struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %sub sampling layer
struct('type', 'c', 'outputmaps', 18, 'kernelsize', 4) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
struct('type', 'c', 'outputmaps', 54, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
};
cnn = cnnsetup(cnn, train_x, train_y);
opts.alpha = 1;
opts.batchsize = 10;
opts.numepochs = 100;
cnn = cnntrain(cnn, train_x, train_y, opts);
[er, bad] = cnntest(cnn, test_x, test_y);
%%plot mean squared error
figure; plot(cnn.rL);