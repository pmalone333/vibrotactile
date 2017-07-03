% things to try 
% 1) compare RT for 3 conditions
% 2) break down acc and RT by VCVs you thought were most helped by the
% vibration vs VCVs that weren't 

load('20170517_1055-MR2_block1.mat'); % no vib
load('20170517_1103-MR2_block1.mat'); % vib speech
load('20170517_1113-MR2_block1.mat'); % vib control



accuracy = zeros(length(trialOutput(1).sResp),1);

for iTrial = 1:length(trialOutput(1).sResp)
    if strcmp(trialOutput(1).sResp{iTrial},trialOutput(1).stimuli{iTrial}(2)), accuracy(iTrial) = 1; end
end

totalAcc = sum(accuracy)/length(accuracy);