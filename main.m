clc; clear all; close all;
%% CONFIG M and N
M = 1;
N = 40;
k = 3;
%% INIT SERVER and DEVICE 1-3
device1 = device(1);
device2 = device(2);
device3 = device(3);

server = server(1);

% display_output([device1,device2,device3],[], 10:10:90 ,[8,15,25],k,2);
% display_output([device1,device2,device3],[],[50,30,20],[8,15,25],k,3);
% display_output([device1,device2,device3],[],[20,30,50],[25,15,8],k,4);
% display_output([device1,device2,device3],[],[20],[25,15,8],k,5);
% display_output([device1,device2,device3],[],[20,30,50],[25],k,6);
% display_output([device1,device2,device3],[],[20,30,50],[25,15,8],k,7);

acc     = [];
t_loc   = [];   e_loc = [];
t_up    = [];   e_up = [];

%% TRAIN @ SERVER
fprintf('|======================================================================================================================|\n');
fprintf('|>>>> Training @ Server\n')
[server.w1, server.w2 , g_acc] = cnn_train(server.x_train , server.y_train, server.x_test, server.y_test, [], [], 5);

for i = 1:M
%% TRAIN @ LOCAL
    fprintf('\n|==== Iteration : %d  ==================================================================================================|\n', i);
    fprintf('|>>>> Training @ Device 1\n')
    [device1.w1, device1.w2, device1.accuracy] = cnn_train(device1.x_train , device1.y_train, device1.x_test, device1.y_test, server.w1, server.w2, N);
    fprintf('|>>>> Training @ Device 2\n')
    [device2.w1, device2.w2, device2.accuracy] = cnn_train(device2.x_train , device2.y_train, device2.x_test, device2.y_test, server.w1, server.w2, N);
    fprintf('|>>>> Training @ Device 3\n')
    [device3.w1, device3.w2, device3.accuracy] = cnn_train(device3.x_train , device3.y_train, device3.x_test, device3.y_test, server.w1, server.w2, N);
    acc(i,:) = [device1.accuracy, device2.accuracy, device3.accuracy];
    
    device1.t_loc = time_at_loc(device1, N);    device1.e_loc = energy_at_loc(device1, N);
    device2.t_loc = time_at_loc(device2, N);    device2.e_loc = energy_at_loc(device2, N);
    device3.t_loc = time_at_loc(device3, N);    device3.e_loc = energy_at_loc(device3, N);
    
    t_loc(i,:) = [device1.t_loc, device2.t_loc, device3.t_loc];
    e_loc(i,:) = [device1.e_loc, device2.e_loc, device3.e_loc];

%% SEND WEIGHT TO SERVER VIA NOMA PROTOCAL
    device1.signal_bin = horzcat(build_data_to_signal(device1.w1), build_data_to_signal(device1.w2));
    device2.signal_bin = horzcat(build_data_to_signal(device2.w1), build_data_to_signal(device2.w2));
    device3.signal_bin = horzcat(build_data_to_signal(device3.w1), build_data_to_signal(device3.w2));
    
    [device1,device2,device3] = comm_to_server(device1, device2, device3, server, 0);
    
    t_up(i,:) = [device1.t_up, device2.t_up, device3.t_up];
    e_up(i,:) = [device1.e_up, device2.e_up, device3.e_up];
    
    %% WEIGHT AGGREGATION @ SERVER
    [server.w1, server.w2] = aggregate_weight([device1, device2, device3]);
end
close all;

%% PRINT OUTPUT
display_output([],[acc,t_loc,e_loc,t_up,e_up],M,N,k,11);    % each device
display_output([],[acc,t_loc,e_loc,t_up,e_up],M,N,k,12);    % accumulate
% display_output([],[acc,t_loc,e_loc,t_up,e_up],M,N,k,13);  % per iteration


% fprintf('training accuracy @ Server = %.2f %%\n', g_acc*100);
% fprintf('training accuracy @ Device 1 = %.2f %%\n', device1.accuracy*100);
% fprintf('training accuracy @ Device 2 = %.2f %%\n', device2.accuracy*100);
% fprintf('training accuracy @ Device 3 = %.2f %%\n', device3.accuracy*100);
