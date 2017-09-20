load('stimuliAllRuns.mat')

stimGenPTB('open','COM2')

f = stimuliAllRuns{1}{7,2}(1,:);
p = stimuliAllRuns{1}{7,2}(2,:);

stim = {...
    {'fixed',f(1),1,90},...
    {'fixchan',p(1),1, 90},...
    {'fixed',f(1),100,190},...
    {'fixchan',p(2), 100,190},...
    {'fixed',f(1),200,290},...
    {'fixchan',p(3), 200,290},...
    };

[t,s]=buildTSM_nomap(stim);


for i=1:10
    stimGenPTB('load',s,t);
    stimGenPTB('start');
    WaitSecs(2);
end

stimGenPTB('close','COM2')

% tm = stim{1}{1};
% ch = stim{1}{2};
% 
% stimGenPTB('open','COM2')
% 
% for i=1:5
%     stimGenPTB('load',ch,tm);
%     stimGenPTB('start');
%     WaitSecs(2);
% end
% 
% stimGenPTB('close','COM2')