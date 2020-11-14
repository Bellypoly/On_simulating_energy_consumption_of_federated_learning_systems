%% AGGREGATE WEIGHT @SERVER
function [w1, w2] = aggregate_weight(device)
    w1 = 0;
    w2 = 0;
    for i = 1:length(device)
        
        w1 = w1 + device(1,i).w1_dec;
        w2 = w2 + device(1,i).w2_dec;
    end
    w1 = w1/length(device);
    w2 = w2/length(device);
clf
end
