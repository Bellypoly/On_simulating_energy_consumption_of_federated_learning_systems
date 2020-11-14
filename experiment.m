function [sum_acc, sum_t_loc,sum_e_loc,sum_t_up,sum_e_up] = experiment(device,m,n, condition)
    sum_t_loc = [];
    sum_e_loc = [];
    sum_t_up = [];
    sum_e_up = [];
    
    train_at_global = -1;
    % train_at_global,limit time
    if(~isempty(condition))
        train_at_global = condition(1);
        time_limit = condition(2);
    end
    for x = 1:length(m)
        M = m(x);
        N = n(x);
        
        %% INIT SERVER and DEVICE 1-3
        device1 = device(1);
        device2 = device(2);
        device3 = device(3);

        s = server(1);

        acc     = [];
        t_loc   = [];   e_loc = [];
        t_up    = [];   e_up = [];

        %% TRAIN @ SERVER
        if(train_at_global)
        fprintf('|======================================================================================================================|\n');
            fprintf('|>>>> Training @ Server\n')
            [s.w1, s.w2 , g_acc] = cnn_train(s.x_train , s.y_train, s.x_test, s.y_test, [], [], 5);
        else
            s.w1 = randn(5,5,1,4);
            s.w2 = randn(5,5,4,12);
        end

        for i = 1:M
        %% TRAIN @ LOCAL
            fprintf('\n|==== Iteration : %d  ==================================================================================================|\n', i);
            fprintf('|>>>> Training @ Device 1\n')
            [device1.w1, device1.w2, device1.accuracy] = cnn_train(device1.x_train , device1.y_train, device1.x_test, device1.y_test, s.w1, s.w2, N);
            fprintf('|>>>> Training @ Device 2\n')
            [device2.w1, device2.w2, device2.accuracy] = cnn_train(device2.x_train , device2.y_train, device2.x_test, device2.y_test, s.w1, s.w2, N);
            fprintf('|>>>> Training @ Device 3\n')
            [device3.w1, device3.w2, device3.accuracy] = cnn_train(device3.x_train , device3.y_train, device3.x_test, device3.y_test, s.w1, s.w2, N);
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

            [device1,device2,device3] = comm_to_server(device1, device2, device3, s, time_limit);

            t_up(i,:) = [device1.t_up, device2.t_up, device3.t_up];
            e_up(i,:) = [device1.e_up, device2.e_up, device3.e_up];

            %% WEIGHT AGGREGATION @ SERVER
            [s.w1, s.w2] = aggregate_weight([device1, device2, device3]);
%         close all;clc;
        end
%         sum_acc(x,:) = sum(sum(acc))/length(device)/m(x);
        sum_acc(x,:) = sum([device1.accuracy, device2.accuracy, device3.accuracy]);
        sum_t_loc(x,:) = sum(sum(t_loc));
        sum_e_loc(x,:) = sum(sum(e_loc));
        sum_t_up(x,:) = sum(sum(t_up));
        sum_e_up(x,:) = sum(sum(e_up));
    end
    sum_acc = sum_acc'./length(device);
    sum_t_loc = sum_t_loc';
    sum_e_loc = sum_e_loc';
    sum_t_up = sum_t_up';
    sum_e_up = sum_e_up';
end
%%
