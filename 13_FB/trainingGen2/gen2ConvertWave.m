%
% TIvals = gen2ConvertWave(waveInfo)
%
% Convert a 2D array of wavelet info to bytes that can be programmed to TI
% NOTE: in input, freq first, then amplitude, but this is reversed for TI chip
%
function rawData = gen2ConvertWave(waveInfo)
    [rows, cols] = size(waveInfo);
    if(cols ~= 5)
        fprintf('gen2ConvertWave error: each row must have 5 elements: freq,amplitude(0-1),num cycles, risetime(ms), falltime(ms)\n');
        rawData = '';
        return;
    end
    
    if(rows > 16)
        fprintf('gen2ConvertWave warning: too many wavelets for default wave representation\n');
    elseif (rows > 8)
        fprintf('gen2ConvertWave caution: too many wavelets for default wave 1-3 representation\n');
    end
    
    % create array that is returned with appropriate types
    rawData = zeros(1,rows*4,'uint8');
    idx = 1;    % pointer to next value to change
    
    for i=1:rows
        vals = waveInfo(i,:);
        % calculate amplitude
        rawData(idx) = uint8(double(vals(2))* 255.0);
        idx=idx+1;        
        % calculate frequency
        rawData(idx) = uint8(double(vals(1))/7.8125);
        idx = idx+1;
        % calculate number of cycles
        rawData(idx) = uint8(vals(3));
        idx = idx+1;
        % rise and fall times are trickier, find closest match
        rawData(idx) = (uint8(16)*uint8(riseFall(vals(4)))) + uint8(riseFall(vals(5)));
        idx = idx + 1;
    end
    return;
end

function v = riseFall(tim)
    % find the closest time in ms to the list here:
    if(tim == 0)
        v = 0;
        return;
    elseif(tim <= 256)
        v = tim/32;
        return;
    else
        v = 7 + (val / 256);
    end
    return;
end
