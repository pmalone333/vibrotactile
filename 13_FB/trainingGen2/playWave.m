%
% playWave(Wave,Chan) - play the specified waveform on the specified chan
%
function playWave(wave, chan)
    % create a struct
    gestureL = [...
    63,chan-1,wave;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,chan-1,wave;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,chan-1,wave;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,chan-1,wave;...
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,0,0;... % delay
    63,chan-1,wave;...
    ];
    rawGesture = gen2ConvertGesture(gestureL);
    piezoDriverGen2('loadGesture',rawGesture);
    piezoDriverGen2('start');
end