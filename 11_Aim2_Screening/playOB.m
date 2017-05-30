load('oddball_aba2_whiteNoiseAmplifiedC.mat')

tm = stim{1}{1};
ch = stim{1}{2};

stimGenPTB('open','COM1')

for i=1:5
    stimGenPTB('load',ch,tm);
    stimGenPTB('start');
    WaitSecs(2);
end

stimGenPTB('close','COM2')