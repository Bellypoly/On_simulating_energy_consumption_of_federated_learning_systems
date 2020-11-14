classdef device
    %DEVICE SummarY_train of this class goes here
    %   Detailed eX_trainplanation goes here
    
    properties
        id
        x_train
        y_train
        x_test
        y_test
        w1              % weight from 1st convolutional layer in CNN LeNet-1
        w2              % weight from 2nd convolutional layer in CNN LeNet-1
        w1_dec          % w1 that convert bin to data from decoded signal
        w2_dec          % w2 that convert bin to data from decoded signal
        signal_bin      % w1 concat w2 and convert to binary data        
        signal          % Transmit signal @ device
        signal_dec      % Signal after decode @ Server
        accuracy        % Training accuracy
        
        flop            % total # of FLOPs require at edge device
        c               % # of FLOPs in CPU cycle
        f               % CPU frequencY_train of whole operation duration
        si              % Const. coefficient depend on chip architecture
        
%         power = amplitude^2
        p_tx            % Transmission power @ device ~ 1 Watt
        p_tx_db         % Transmission power in dB @ device
        h               % Channel power gain @ device
        a               % Power allocation factors
        r               % Achievable rate (in bits per second) @ Device 
        
        t_up            % Time uploading parameter to Server
        t_loc           % Time computing weight training @ Device
        e_up            % Energy consumption when uploading parameter to Server
        e_loc           % Energy consumption when weight training @ Device
        
        d               % distance between Device to Server
    end
    
    methods
        function obj = device(id)
            %% READ MNIST BINARY FILE and CREATE IMAGE ARRAY
            ImagesTrain = processImagesMNIST('dataset\train-images.idx3-ubyte');
            LabelsTrain = processLabelsMNIST('dataset\train-labels.idx1-ubyte');
            ImagesTest = processImagesMNIST('dataset\t10k-images.idx3-ubyte');
            LabelsTest = processLabelsMNIST('dataset\t10k-labels.idx1-ubyte');
            
            obj.x_test = ImagesTest(:,:,1,1:1000);
            obj.y_test = LabelsTest(1:1000);
            
            if(id == 1)
                obj.id = id;
                obj.x_train = ImagesTrain(:,:,1,8001:8300);        % DATASET MNIST@DEVICE 1 train : 0-300 | 1000 for test
                obj.y_train = LabelsTrain(8001:8300);
                obj.si = 0.0045*10^-21;
%                 obj.p_tx_db = -30;
                obj.p_tx_db = 21;
                
                % Cortex-A76
                obj.f = 3*10^9;     % Hz

                obj.c = 16;         % Flop/Cycle
                obj.d = 100;
            elseif(id == 2)
                obj.id = id;
                obj.x_train = ImagesTrain(:,:,1,8301:8600);      % DATASET MNIST@DEVICE 2 train : 301-600 | 1000 for test
                obj.y_train = LabelsTrain(8301:8600);
                obj.si = 0.0049*10^-21;
%                 obj.p_tx_db = -30;
                obj.p_tx_db = 27;

                % Samsung-M1
                obj.f = 2.6*10^9;	% Hz
                obj.c = 6;          % Flop/Cycle
                obj.d = 150;
            elseif(id == 3)
                obj.id = id;
                obj.x_train = ImagesTrain(:,:,1,8601:9000);     % DATASET MNIST@DEVICE 2 train : 601-1000 | 1000 for test
                obj.y_train = LabelsTrain(8601:9000);
                obj.si = 0.0001*10^-21;
%                 obj.p_tx_db = -30;
                obj.p_tx_db = 30;

                % Cortex-A76
                obj.f = 3*10^9;     % Hz
                obj.c = 16;         % Flop/Cycle
                obj.d = 200;
            else
                obj.x_train = ImagesTrain;
                obj.y_train = LabelsTrain;
                obj.x_test = ImagesTest;
                obj.y_test = LabelsTest;
            end
            m = cnn_model();
            obj.flop = m.flop();
%             obj.p = 1;
%             obj.h = 1/3;
        clc    
        end
        function p_watt = tx_power_in_linear(obj,p_tx_db)
            %	p_tx_db power in dBm
            p_watt = (10^-3)*db2pow(obj.p_tx_db);
        end
    end
end