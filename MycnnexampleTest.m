%{
neg = 112; %û��Ŀ���ͼ��
pos = 112; %��Ŀ���ͼ��
[test_x, test_y] = GDInit('D:\!zju\��Graduation design\image\s\small_48\', [neg,pos]); 
cnn.layers = {
struct('type', 'i') %input layer
struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
};
opts.alpha = 1;
opts.batchsize = 56; %���������ݴ��Һ� ��size(train_x,3) / opts.batchsize������cnn��ÿ������ѵ��һ�Σ�
opts.numepochs = 1000; %����������opts.numepochs�Σ�ÿ������ѵ��10�Σ�
%}
%% ��������
load Mycnnexample_0
%test_x = ;
%test_y = ;

%% ��������
t = tic;
fprintf('\n���ڲ�������...');
[er, bad, hh, aa] = cnntest(cnn, test_x, test_y);
fprintf(' ��� ���Ժ�ʱ��');
toc(t);

%% �����ͼ
%%plot mean squared error
figure; plot(cnn.rL);

