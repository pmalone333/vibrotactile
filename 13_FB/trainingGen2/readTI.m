%
% readTI - read some memory location from TI chip
% assumes that the channel is already open
% args:
% channel (0-31, addr (0-2303), numBytes)
function vals = readTI(addr, num, chan) 
    if exist('num','var') == 0
        fprintf('syntax: readTI(addr, numbytes, chan(0-31)\n');
        return;
    end

    vals = piezoDriverGen2('readTIlocs',addr,num,chan+1);
end
