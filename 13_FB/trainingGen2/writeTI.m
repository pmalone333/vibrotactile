% test write TI mode
function rtn = writeTI(addr, data, chans)
    if exist('data','var') == 0
        fprintf('syntax: writeTI(addr, data, chans(0-31)\n');
        return;
    end
    vals = piezoDriverGen2('writeTIlocs',addr,data,chans+1);
end
