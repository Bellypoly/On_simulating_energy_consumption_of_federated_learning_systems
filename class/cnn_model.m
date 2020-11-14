classdef cnn_model
    %CNN_MODEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        input_size
        cov1_size
        cov1_num
        padding_size
        pool_size
        pool_output_num
        step_size
        cov2_size
        cov2_num
        output_size
    end
    
    methods
        function obj = cnn_model()
%           if(id == 1)
            % CNN_MODEL Lenet-1
            obj.input_size = [28 28 1];
            obj.cov1_size = 5;
            obj.cov1_num = 4;
            obj.padding_size = 1;
            obj.pool_size = 2;
            obj.pool_output_num = 4;
            obj.step_size = 2;
            obj.cov2_size = 5;
            obj.cov2_num = 12;
            obj.output_size = 10;
%             end
        end
        
        function flop = flop(obj)
        % ----------------------------------------------------------------------------------------------- %
        %| [36]                                                                                          |%
        %| CONVOLUTION_FLOPs = (spartial_w x spartial_h) x depth_n x (kernel_w x kernel_h) x depth_(n-1) |%
        %| - spartial_w = spartial_w_of_map                                                              |% 
        %| - spartial_h = spartial_h_of_map                                                              |% 
        %| - depth_n    = current layer depth                                                            |% 
        %| - depth_(n-1)= previous layer depth                                                           |% 
        %| - kernel_w   = kernel width                                                                   |% 
        %| - kernel_h   = kernel height                                                                  |%
        %|                                                                                               |%  
        %| FULLY-CONNECTED_FLOPs = #output x #input                                                      |%
        %| - #output    = # of Fully connected output                                                    |%
        %| - #input     = (kernel_w x kernel_h) x depth_(n-1)                                            |% 
        % ----------------------------------------------------------------------------------------------- %
%             convolution_layer1 = (28*28)*4*(5*5)*1;
%             convolution_layer2 = (12*12)*12*(5*5)*4;
%             fully_connected_layer = (10)*(4*4*12);
            
            convolution_layer1 = (obj.input_size(1)*obj.input_size(2))*obj.cov1_num*(obj.cov1_size*obj.cov1_size)*obj.input_size(3);
                %   (spartial_w x spartial_h)   --> (obj.input_size(1)*obj.input_size(2))
                %   (kernel_w x kernel_h)       --> (obj.cov1_size*obj.cov1_size)
                %   depth_n                     --> obj.cov1_num
                %   depth_(n-1)                 --> obj.input_size(3)
            convolution_layer2 = (obj.cov2_num*obj.cov2_num)*obj.cov2_num*(obj.cov2_size*obj.cov2_size)*obj.cov1_num;
                %   (spartial_w x spartial_h)   --> (obj.cov2_num*obj.cov2_num)
                %   (kernel_w x kernel_h)       --> (obj.cov2_size*obj.cov2_size)
                %   depth_n                     --> obj.cov2_num
                %   depth_(n-1)                 --> obj.cov1_num
            fully_connected_layer = (obj.output_size*1*1)*(4*4*obj.cov2_num);
                %   #output                     --> (obj.output_size*1*1)
                %   #input                      --> (kernel_w x kernel_h) x depth_(n-1) 
                %                               --> (4*4*obj.cov2_num)
            

            flop = convolution_layer1...
                + convolution_layer2...
                + fully_connected_layer;
        end
    end
end

