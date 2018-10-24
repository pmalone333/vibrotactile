%
% Toverlay(key, pulseArr, startIdx)
%
% Use the key to install specified pulses for overlay
%
function arr = Toverlay(key, arr, arrPtr, WFlengths, strategy)
    if exist('strategy','var') == 0
        strategy = 'drop';
    end
    
    [r,c] = size(key); 
    [ar, ac] = size(arr);
    for i=1:r
        % process the request, but if channel occupied, use strategy
        time = key(i,1);
        chan = key(i,2);
        wf = key(i,3);
        %[time, chan, wf] = key(i,:);
        % check whether channel is free
        startTime = arrPtr + time;
        endTime = startTime + WFlengths(wf);
        if endTime > ac
            endTime = ac; % allow waveform to overflow?
        end
        
        % are all chan-time slots available for waveform?
        if sum(arr(chan, floor(startTime):floor(endTime)) ~= 0) > 0
            continue; % channel busy, do not write specified pulse
        end
        
        % if we have gotten here, do update
        % allow waveform to go past phoneme boundary?
        % what happens if channel needed for formants?
        try 
            arr(chan, floor(startTime)) = wf;
            arr(chan, floor(startTime+1):floor(endTime)) = -1;
        catch
            foo = 1;
        end
    end
end %fn
