%% TRAIN
function [w1, w2, accuracy] = cnn_train(x_train, y_train, x_test, y_test, w1, w2, N)
    m = cnn_model(); % m = model
%     a = m.flop_cnn()
    %--- DEFINE LAYER ---%
        layers = [
        imageInputLayer(m.input_size)                                                       % [28 28 1]

        convolution2dLayer(m.cov1_size,m.cov1_num,'Padding',m.padding_size,'Weights', w1)   % [5x5x4]
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(m.pool_size,'Stride',m.step_size)                                 % [2x2]

        convolution2dLayer(m.cov2_size,m.cov2_num,'Padding',m.padding_size,'Weights', w2)   % [5x5x12]
        batchNormalizationLayer
        reluLayer

        maxPooling2dLayer(m.pool_size,'Stride',m.step_size)                                 % [2x2]

        fullyConnectedLayer(m.output_size)                                                  % 10
        softmaxLayer
        classificationLayer];

    %--- TRAIN CONFIGURATION ---%
    miniBatchSize = 100;
    Epoch = N;
    options = trainingOptions( 'sgdm',...
        'MaxEpochs',Epoch, ...
        'ValidationData',{x_test, y_test});%, ...
%         'MiniBatchSize', miniBatchSize,...
%         'Plots', 'training-progress'); 
%         'InitialLearnRate',0.01,...
%         'Shuffle','every-epoch', ...
%         'ValidationFrequency',30, ...
%         'Verbose',false, ...
%     tic
    net = trainNetwork(x_train, y_train, layers, options);
%     toc
    
%     time = toc;
    w1 = net.Layers(2).Weights;
    w2 = net.Layers(6).Weights;
    
    %--- COMPARE WITH TEST DATASET ---%
    predLabelsTest = net.classify(x_test);
    accuracy = sum(predLabelsTest == y_test) / numel(y_test);

%     disp('-----------')
%     disp(net.Layers(2).Weights)
%     disp('-----------')
%     disp(net.Layers(6).Weights)
%     disp('-----------')

    fprintf('| training accuracy = %.2f %%\n', accuracy*100)
    fprintf('|- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |\n');
    clc
end