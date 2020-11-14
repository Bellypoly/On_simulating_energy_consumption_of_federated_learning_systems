classdef server
    %SERVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        x_train
        y_train
        x_test
        y_test
        w1
        w2
        p           %   total power @ server
    end
    
    methods
        function obj = server(id)
            %% READ MNIST BINARY FILE and CREATE IMAGE ARRAY
            ImagesTrain = processImagesMNIST('dataset\train-images.idx3-ubyte');
            LabelsTrain = processLabelsMNIST('dataset\train-labels.idx1-ubyte');
            ImagesTest = processImagesMNIST('dataset\t10k-images.idx3-ubyte');
            LabelsTest = processLabelsMNIST('dataset\t10k-labels.idx1-ubyte');
            
            if(id == 1)
                % DATASET MNIST@SERVER 1 train : 1-8000 | 2000 for test
                obj.x_train = ImagesTrain(:,:,1,1:8000);
                obj.y_train = LabelsTrain(1:8000);
                obj.x_test = ImagesTest(:,:,1,2001:4000);
                obj.y_test = LabelsTest(2001:4000);
            elseif(id == 0)
                obj.x_train = ImagesTrain;
                obj.y_train = LabelsTrain;
                obj.x_test = ImagesTest;
                obj.y_test = LabelsTest;
            end
            obj.p = 1;
        clc
        end
        
%         function p_tx = tx_power_in_linear(obj,distance)
%             c = communication();
%             %	Transmit power in dBm
%             %   may be change ---> finde relation btw path loss fn and p_tx
%             %   Pl = p_tx*K(d_k/d_0)^c.path_loss_exp
%         end
    end
end

