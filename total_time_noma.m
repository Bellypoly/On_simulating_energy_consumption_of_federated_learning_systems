%% T_NOMA = time delay for both local ML-parameter update & uploading 
function time = total_time_noma(t_local, t_upload, M, N)
    time = M*(N*t_local+t_upload);
end