classdef communication
    %COMMUNICATION Summary of this class goes here
    %   config variable in communication part from device to server (base station)
    
    properties
%	s = # of bits required @ edge device to send the local ML-parameters to edge server
        s 
        path_loss_exp   %   path loss exponent
%   d = distance from Device to Server (Base Station)
        d_0             %   reference distance
        d_1             %   distance 1
        d_2             %   distance 2
        d_3             %   distance 3
        d_max           %   maximum distance for attenuation calculation
        h_0             %   channel power gain at a reference distance of d_0 --> β_0
%         h_k           %   channel power gain from edge device k to the edge server
%         p_k
        bw = 2          %   bandwidth(MHz)
        noise_power_db  %   noise power @ server (dBm)
        noise_power
    end
    
    methods
        function obj = communication()
            m = cnn_model();
            obj.s = (((m.cov1_size^2)* m.cov1_num) + (m.cov2_size^2)*m.pool_output_num*m.cov2_num)*32;
            obj.path_loss_exp = 3;
            obj.d_0 = 1;
            obj.d_1 = 100;
            obj.d_2 = 150;
            obj.d_3 = 200;
            obj.d_max = 500;
            obj.h_0 = 30;
            obj.bw = 2*10^6;                     %   MHz
            obj.noise_power_db = -100;      %   dBm/Hz
        end
        
        function no = noise_power_in_db(obj,bw)
            %   Calculate noise power in dBm
            %   bw - bandwidth in MHz
            bw = obj.bw;
            no = -174 + 10*log10(bw);
        end
        function p_watt = noise_power_in_linear(obj,noise_power_db)
            %   Calculate noise power in "dBm" to "Watt"
            %	noise_power_db - p_tx_db power in dBm
            p_watt = (10^-3)*db2pow(obj.noise_power_db);
        end
    end
end

