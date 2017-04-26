clear; clc; close;
load('2015-12-18-1000_block1.run1.mat');

% subplot(2,1,1)
% plot(trialOutput.trialDuration);
% title('all Trials')
% xlabel('Trials')
% ylabel('Duration')
% 
% % hold on;
% 
% subplot(2,1,2)
% plot(trialOutput.trialDuration(2:end));
% title('All Trials except 1st')
% xlabel('Trials')
% ylabel('Duration')

% subplot(2,1,1)

% idx = find(trialOutput.stimulusOneDuration < 0);
% trialOutput.stimulusOneDuration(idx) = NaN;
% plot(trialOutput.stimulusOneDuration);
% title('Time takes to call the functions to deliver stimulus 1. Empry time points are Null trials')
% xlabel('Trials')
% ylabel('Stimulus One Duration.')

idx = find(trialOutput.stimulusTwoDuration > 2);
trialOutput.stimulusTwoDuration(idx) = NaN;
plot(trialOutput.stimulusTwoDuration);
title('Time takes to call the functions to deliver stimulus 2. Empry time points are Null trials')
xlabel('Trials')
ylabel('Stimulus One Duration.')


% hold on;
% 
% subplot(2,1,2)
% plot(trialOutput.trialDuration(2:end));
% title('All Trials except 1st')
% xlabel('Trials')
% ylabel('Duration')