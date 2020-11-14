function device = time_and_energy_upload(device, time_limit)
    % device input array would be orederd following SIC order
    % ------------------------------------------------------------------------------ %
    %| >>>  power allocation coefficients                                           |%
    %| >>>  a -	Assuming the server (base station) has total power of 1 watt        |%
    %|          and will allocate power for each Device as proportional             |%
    %|          to squared distance                                                 |%
    %|      Power ~ distance^2                                                      |%
    % ------------------------------------------------------------------------------ % 
    c = communication();
    sum = 0; sum_1 = 0;
    %% Time for uploading parameter
    for k = 1:length(device)
        for j = 1:k
          sum = sum + (device(j).p_tx*device(j).a);
          if(j-1 > 0)
              sum_1 = sum_1 + (device(j-1).p_tx*device(j-1).a);
          else
              sum_1 = sum_1 + 0;
          end
        end
        
        device(k).r = c.bw*log2(((c.noise_power_db^2)+sum)./((c.noise_power_db^2)+sum_1));
        
        if(time_limit > 0)
            % limit_time = t_loc + t_up
            % t_up = time_limit - t_loc
            % t_up * r_k >= S
            % So (time_limit - t_loc) * r_k >= S
            device(k).t_up = time_limit - device(k).t_loc;
            c.s = device(k).t_up .* device(k).r;
        else 
            device(k).t_up = c.s ./ device(k).r;
        end
        
        %% Energy for uploading parameter
        device(k).e_up = device(k).p_tx * device(k).t_up;
    end
end

