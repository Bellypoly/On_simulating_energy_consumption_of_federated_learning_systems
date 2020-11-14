function [device1,device2,device3] = comm_to_server(device1,device2,device3,server, time_limit)
    c = communication();

    %% Build binary signal to send to Server
    
    % Do QPSK modulation of data
    qpsk_mod = comm.QPSKModulator('BitInput',true);
    
    x1_mod = step(qpsk_mod, device1.signal_bin');
    x2_mod = step(qpsk_mod, device2.signal_bin');
    x3_mod = step(qpsk_mod, device3.signal_bin');
    
    % ------------------------------------------------------------------------------ %
    %| >>>  power allocation coefficients                                           |%
    %| >>>  a -	Assuming the server (base station) has total power of 1 watt        |%
    %|          and will allocate power for each Device as proportional             |%
    %|          to squared distance (which serves the user with                     |%
    %|          the best channel gain at any time)                                  |%
    %|      Power ~ distance^2                                                      |%
    % ------------------------------------------------------------------------------ %    
    sum2_d = device1.d^2+device2.d^2+device3.d^2;
    
    device1.a = server.p*(device1.d^2)/sum2_d;
    device2.a = server.p*(device2.d^2)/sum2_d;
    device3.a = server.p*(device3.d^2)/sum2_d;

    % Do power-domain Multiplexing (superposition encoding)
    device1.signal = (sqrt(device1.a).*x1_mod);
    device2.signal = (sqrt(device2.a).*x2_mod);
    device3.signal = (sqrt(device3.a).*x3_mod);
    
    signal = device1.signal;
    signal = device2.signal + signal;
    signal = device3.signal + signal;
    
%     plot_signal(device1.signal_bin(1:32), device2.signal_bin(1:32), device3.signal_bin(1:32), 0, 3, 1)
%     plot_signal(x1_mod(1:16), x2_mod(1:16), x3_mod(1:16), 1, 3, 2)
%     plot_signal(device1.signal(1:16), device2.signal(1:16), device3.signal(1:16), 1, 3, 3)
%     plot_signal(signal(1:16), [], [], 1, 1, 4)

    [device1,device2,device3] = decode_at_server(device1,device2,device3,signal, time_limit);

    [device1.w1_dec, device1.w2_dec] = build_signal_to_data(device1.signal_dec);
    [device2.w1_dec, device2.w2_dec] = build_signal_to_data(device2.signal_dec);
    [device3.w1_dec, device3.w2_dec] = build_signal_to_data(device3.signal_dec);
clf
end