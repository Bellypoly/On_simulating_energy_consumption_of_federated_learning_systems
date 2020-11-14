%% Ek %% = total energy consumption at edge device
function loc_energy = energy_at_loc(device, N)
    loc_energy = ((length(device.y_train)*device.flop)/device.c)*device.si*(device.f^2);
    loc_energy = loc_energy*N;
end