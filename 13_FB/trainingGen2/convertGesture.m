%
% uint16 convertGesture(gesture) - convert triplet-specified gestures into
% raw data that can be sent to Gen-2 stimulator
%

function rawArray = gen2ConvertGesture(gesture)

[r,c] = size(gesture);
rawArray = 'ERROR';
if c ~= 3
    fprintf('convertGesture: must specify rows of: time(0-63),channel (0-31), waveform (0-31)\n');
    return;
end

rawArray = zeros(1,r,'uint16');
for i=1:r
    val = uint16(0);
    % convert a triplet, do time first
    triplet = gesture(i,:);
    if triplet(1) < 0 || triplet(1) > 63
        fprintf('convertGesture ERROR: row %d time %d is outside range [0,63]\n', i, uint16(triplet(1)));
    else
        val = uint16(triplet(1)) * uint16(1024);
    end
    % likewise do channel
    if triplet(2) < 0 || triplet(2) > 31
        fprintf('convertGesture ERROR: row %d channel %d is outside range [0,31]\n', i, uint16(triplet(2)));
    else
        val = val + uint16(triplet(2)) * uint16(32);
    end
    % and waveform
    if triplet(3) < 0 || triplet(3) > 31
        fprintf('convertGesture ERROR: row %d waveform %d is outside range [0,31]\n', i, uint16(triplet(3)));
    else
        val = val + uint16(triplet(3));
    end
    % and write it back
    rawArray(i) = val;
end
