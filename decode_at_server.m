function [device1,device2,device3] = decode_at_server(device1,device2,device3,rx_signal, time_limit)
    c = communication();
    
     %% y - received signal at the Server%%
    % ------------------------------------------------------------------------------ %
    %| received signal at the Server   = [sum of products sqrt(power)*signal] + z	|%
    %|                                 = sum__k=1 to K(sqrt(p_k x h_k) x X_k) + z	|%
    %| - p_k = transmission power @ Device                                          |% 
    %| - h_k = channel power gain from device to the Server                         |% 
    %| - x_k = transmit signal @ Device (x_mod)                                     |% 
    %| - z   = additive white Gaussian noise @ Server                               |%
    %          ~ a CSCG random variable with mean=0 and variance σ^2                |%  
    % ------------------------------------------------------------------------------ %
    %| Path Loss Equation                                                           |%
    %| Given    P_r = β_0*(d_k/d_0)^-path_loss_exp                                  |%
    %|                                                                              |%
    %| from ref : http://www.sis.pitt.edu/prashk/inf1072/Fall16/lec5.pdf            |%
    %|          P_r = (p_k / (L_0*(d_k/d_0)^path_loss_exp)))                        |%
    %|              = (p_k/L_0)*(d_k/d_0)^-path_loss_exp                            |%
    %| So β_0 = (p_k/L_0)                                                           |%
    %|                                                                              |%
    %| L_0  -   constant that is computed at a reference distance(d_0)              |%
    %|          (path loss at the first	meter (put d = 1 meter)                     |%
    %|                                                                              |%
    % -----------------------------------------------------------------------------  %
    %     device1.p_tx = device1.tx_power_in_linear(0:2:c.h_0);
%     p1 = device1.p_tx_db;
%     p2 = device2.p_tx_db;
%     p3 = device3.p_tx_db;
    device1.p_tx = device1.tx_power_in_linear(device1.p_tx_db);
    device2.p_tx = device2.tx_power_in_linear(device2.p_tx_db);
    device3.p_tx = device3.tx_power_in_linear(device3.p_tx_db);
    
    % ------------------------------------------------------------------------------- %
    %| >>>  channel power gain from Device to the Server (multiplier)                |%
    %| >>>  h_k -	channel attenuation gain for the link between Server and Device. |%
    %|              Attenuation is inversely proportional to the power               |%
    %|              and directly proportional to squared distance.                   |%
    % ------------------------------------------------------------------------------- %

    % Generate Rayleigh power gain channel for Devices
    device1.h = sqrt(device1.d^-c.path_loss_exp)*(randn(c.s/2,1) + 1i*randn(c.s/2,1))/sqrt(2);
    device2.h = sqrt(device2.d^-c.path_loss_exp)*(randn(c.s/2,1) + 1i*randn(c.s/2,1))/sqrt(2);
    device3.h = sqrt(device3.d^-c.path_loss_exp)*(randn(c.s/2,1) + 1i*randn(c.s/2,1))/sqrt(2);    

    % ------------------------------------------------------------------------------- %
    %| >>>  additive white Gaussian noise (AWGN) @ Server                            |%
    %| >>>  z -	'randn' generates numbers in [-Inf,+Inf], normally distributed       |%
    %|          Mean is zero, but with strong concetration in [-1 to +1];            |%
    %|                                                                               |%
    %| Since 'randn' concetrates in [-1to+1] or even larger and a bit is only [0or1] |%
    %| and Power<=1 the SNR could be too low --> reducing Noise level is necessary   |%
    % ------------------------------------------------------------------------------- %      
    % received signal @ Server
    % y = [sum of products sqrt(p_k x h_k)*signal] + z
%     device1.signal = awgn((sqrt(device1.p_tx * device1.h).*signal),0);
%     device2.signal = awgn((sqrt(device2.p_tx * device2.h).*signal),0);
%     device3.signal = awgn((sqrt(device3.p_tx * device3.h).*signal),0);

%   c.noise_power_db = c.noise_power_in_db(c.bw)
%   c.noise_power = (10^-3)*db2pow(c.noise_power_db);    % Noise power -- (linear scale)
    c.noise_power = c.noise_power_in_linear();
    
    % Generate AWGN
    z_1 = sqrt(c.noise_power)*(randn(c.s/2,1) + 1i*randn(c.s/2,1))/sqrt(2);
    z_2 = sqrt(c.noise_power)*(randn(c.s/2,1) + 1i*randn(c.s/2,1))/sqrt(2);
    z_3 = sqrt(c.noise_power)*(randn(c.s/2,1) + 1i*randn(c.s/2,1))/sqrt(2);
    
    device1.signal = (sqrt(device1.p_tx * device1.h).*rx_signal) + z_1;
    device2.signal = (sqrt(device2.p_tx * device2.h).*rx_signal) + z_2;
    device3.signal = (sqrt(device3.p_tx * device3.h).*rx_signal) + z_3;

    % ------------------------------------------------------------------------------- %
    %% Decode signal                                                                 |%
    % ------------------------------------------------------------------------------- %
    qpsk_mod = comm.QPSKModulator('BitInput',true);
    qpsk_demod = comm.QPSKDemodulator('BitOutput',true); 
    % equalization
    eq_1 = device1.signal ./ sqrt(device1.h);
    eq_2 = device2.signal ./ sqrt(device2.h);
    eq_3 = device3.signal ./ sqrt(device3.h);
    
    dev = time_and_energy_upload([device1,device2,device3], time_limit);
    
    device1 = dev(1);
    device2 = dev(2);
    device3 = dev(3);
    
    % Decode signal from Device 1
    % >>>   Direct decoding
    signal_1 = step(qpsk_demod, eq_1);
    
    % Decode signal from Device 2
    % >>>   1) demodulation to get device1's signal
    %       2) remodulation of device1
    %       3) MMSE-SIC to remove device1's signal
    %       4) demodulation to get device2's signal
    de1_at_2 = step(qpsk_demod, eq_2);
    rede1_at_2 = step(qpsk_mod, de1_at_2);
    rm_1_at_2 = eq_2 - sqrt(device1.a * device1.p_tx) * rede1_at_2;
    signal_2 = step(qpsk_demod, rm_1_at_2);
    
    % Decode signal from Device 3
    % >>>   1) demodulation to get device1's signal
    %       2) remodulation of device1's signal
    %       3) MMSE-SIC to remove device1's signal
    %       4) demodulation to remaining signal(Device 2&3)
    %       5) remodulation of device2's signal
    %       6) MMSE-SIC to remove device2's signal
    %       7) emodulation to remaining signal(Device 3)
    de1_at_3 = step(qpsk_demod, eq_3);
    rede1_at_3 = step(qpsk_mod, de1_at_3);
    rm_1_at_3 = eq_3 - sqrt(device1.a * device1.p_tx) * rede1_at_3;
    rede_at_3 = step(qpsk_demod, rm_1_at_3);
    rede_2_at_3 = step(qpsk_mod, rede_at_3);
    rm_2_at_3 = rm_1_at_3 - sqrt(device2.a * device2.p_tx)*rede_2_at_3;
    signal_3 = step(qpsk_demod, rm_2_at_3);
    
    device1.signal_dec = signal_1';
    device2.signal_dec = signal_2';
    device3.signal_dec = signal_3';
clf
end

