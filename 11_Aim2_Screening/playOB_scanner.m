load('oddball_aba2_whiteNoiseAmplifiedC.mat')

tm = stim{1}{1};
ch = stim{1}{2};

stimGenPTB_scanner('open','COM2')

for i=1:5
    stimGenPTB_scanner('load',ch,tm);
    stimGenPTB_scanner('start');
    WaitSecs(2);
end

stimGenPTB_scanner('close','COM2')