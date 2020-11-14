%% Fk %%
function flop = flop(a, dataset)
% ---------------------------------------------------------- %
%| [16]                                                     |%
%| flop = a*|Dk|                                            |%
%|  - a    = # of FLOPs / each data sample per local update |%
%|  - |Dk| = size of data sample                            |%
% ---------------------------------------------------------- %
    flop = a*size(dataset);
end