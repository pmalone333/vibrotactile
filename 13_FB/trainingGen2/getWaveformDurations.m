%
% getWaveformDurations(waveforms) - calculate durations of waveforms
%
% print float durations for each waveform, but return rounded-up number of ms.
% 
% ASSUMES THAT ALL WAVEFORMS PROGRAMMED INTO ALL STIMULATORS
%
function durations = getWaveformDurations(wf_specs)
    durations = zeros(1,31);

    for i=1:numel(wf_specs)
        spec = wf_specs{i};
        wf = spec{1};
        wfdata = spec{4};
        % calculate duration in ms from frequency and number of cycles
        if spec{3} < 0 % sampled data
            dur = numel(wfdata) / 7.8125;
        else
            wfdata = spec{4};
            [r,~] = size(wfdata);
            dur = 0;
            for j=1:r
                freq = wfdata(j,1);
                cyc = wfdata(j,3);
                % see formula for converting freq to raw
                % maps to closest freq (round up or down from half Hz)
                freqRaw = double(uint8(freq/7.8125));
                dur = dur + (cyc * 1000.0 / (freqRaw * 7.8125));
            end
        end
        %fprintf('waveform %d duration = %f ms\n',wf,dur);
        durations(wf) = ceil(dur);
    end % for
end % function
