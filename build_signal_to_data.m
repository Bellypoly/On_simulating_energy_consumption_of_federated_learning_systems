function [bin_to_data_marray_w1, bin_to_data_marray_w2] = build_signal_to_data(signal_decode)
    m = cnn_model();
    w1_size = (m.cov1_size^2)*1*m.cov1_num;
%     w2_size = (m.cov2_size^2)*m.pool_output_num*m.cov2_num;
    signal = reshape(signal_decode,32,[]);
    bin_to_data = typecast(uint32(bin2dec(num2str(signal','%d'))),'single');
    bin_to_data_marray_w1 = reshape(bin_to_data(1:w1_size), m.cov1_size, m.cov1_size,1,m.cov1_num);
    bin_to_data_marray_w2 = reshape(bin_to_data(w1_size+1:length(bin_to_data)), m.cov2_size, m.cov2_size,m.pool_output_num,m.cov2_num);
clf
end

