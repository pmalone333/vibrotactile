stimGenPTB('open','COM2');

times =  [uint16(1000),uint16(2000),uint16(3000),uint16(4000),uint16(5000),uint16(6000),uint16(7000),uint16(8000)];
% 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 
pulseVal = uint16(1);
pulses = [pulseVal,pulseVal,pulseVal,pulseVal,pulseVal,pulseVal,pulseVal,pulseVal];

stimGenPTB('load',pulses,times);
stimGenPTB('start');

load('VTspeechStim_OBscan_practice.mat');
    stimuli = stim{1};
    label = labels{1};
   
    for i=1:8

    tm = stimuli{i,1}{1};
ch = stimuli{i,2}{2};

stimGenPTB('load',ch,tm);
stimGenPTB('start');
WaitSecs(2);
    end

stimGenPTB('close','COM2');



