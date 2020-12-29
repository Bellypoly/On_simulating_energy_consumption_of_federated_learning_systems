function signal = build_data_to_signal(data)
% --------------------------------------------------------------------- %
%| IEEE754 Single precision floating point number. ~ length 32 bits    |%
%|  1    bit    (31)     - s - sign                                    |%
%|  8    bits   (30-23)  - e - exponent                                |%
%|  23   bits   (22- 0)  - m - floating point number (mantissa)        |%
%|                                                                     |%
%| Equation -                                                          |%
%|  (-1)^sign *  2^(exponent-1023) * (1 + floating/(2^52)),            |%
% --------------------------------------------------------------------- %

%% CONVERT DATA to BINARY
    hex = num2hex(single(data));    % string of 16 hex digits for x
    dec = hex2dec(hex);             % decimal for each digit (1 per row)
    data_to_bin_marray = dec2bin(dec,4); % 4 binary digits per row
    data_to_bin = logical(data_to_bin_marray-'0');
    
    signal = reshape(data_to_bin',1,[]);
    
%     disp(data)
%     disp(data_bin)
%     disp(signal)
end
