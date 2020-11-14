%% tk %% = computation time duration for each loacal update at edge device
function loc_time = time_at_loc(device,N)
    loc_time = length(device.y_train)*(device.flop/device.c)*(1/device.f);
    loc_time = loc_time*N;
end
