clc;clear;
%% ��������
t = tic;
fprintf('\n���ڶ�������...');


neg = 112; %û��Ŀ���ͼ��
pos = 112; %��Ŀ���ͼ��
[test_x, test_y] = GDInit('D:\!zju\��Graduation design\image\s\small_48\', [neg,pos]); 

%{
neg = 19;
pos = 21;
[test_x, test_y] = GDInit('D:\!zju\��Graduation design\image\cut250\', [neg,pos]);
%}
train_x = test_x(:,:, [1:100, neg+1:neg+100]); % ����ѡ��ȫ�����ݶ�ѵ����һ�������һ������������
train_y = test_y(:, [1:100, neg+1:neg+100]);
time_input = toc(t);
fprintf(' ��� ��ʱ��%.2f s', time_input);

%% ��ʼ������ṹ
t = tic;
rng('default');
cnn.layers = {
struct('type', 'i') %input layer
struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
struct('type', 's', 'scale', 2) %subsampling layer
};
fprintf(['\n���ڳ�ʼ������ṹ...', cnn.layers{1,1}.type, ' ', cnn.layers{2,1}.type, num2str(cnn.layers{2,1}.kernelsize),'-',num2str(cnn.layers{2,1}.outputmaps), ' ', cnn.layers{3,1}.type, num2str(cnn.layers{3,1}.scale), ' ', cnn.layers{4,1}.type, num2str(cnn.layers{4,1}.kernelsize), '-',num2str(cnn.layers{4,1}.outputmaps), ' ', cnn.layers{5,1}.type, num2str(cnn.layers{5,1}.scale), ' ']);
cnn = cnnsetup(cnn, train_x, train_y);
time_build = toc(t);
fprintf(' ��� ��ʱ��%.2f s', time_build);

%% ѵ��
t = tic;
fprintf('\n����ѵ������... ');
opts.alpha = 1;
opts.batchsize = 40; %���������ݴ��Һ� ��size(train_x,3) / opts.batchsize������cnn��ÿ������ѵ��һ�Σ�
opts.numepochs = 100; %����������opts.numepochs�Σ�ÿ������ѵ��100�Σ�
fprintf('С����=%d ������epoch=%d \n', size(train_x,3) / opts.batchsize, opts.numepochs);
cnn = cnntrain(cnn, train_x, train_y, opts);
time_train = toc(t);
fprintf(' ��� ѵ����ʱ��%.2f min', time_train/60);

%%������
t = tic;
fprintf('\n���ڲ�������...');
[error_rate, error_list, prediction_label_list, right_label_list] = cnntest(cnn, test_x, test_y);
time_test = toc(t);
fprintf(' ��� ���Ժ�ʱ��%.2f s', time_test);
fprintf('\n���ܺ�ʱ����%.2f min', (time_test+time_train+time_build+time_input)/60);

%% �����ͼ
%%plot mean squared error
figure; plot(cnn.rL);
