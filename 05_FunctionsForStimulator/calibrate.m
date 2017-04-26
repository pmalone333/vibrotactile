% Calibrate the stimulator
function calibrate(stimDur)

%% What is the stimulus duration?
if (nargin < 1) stimDur = 400; end
% pauseDur = 0.01;


%% close/open the right ports
try
stimGenPTB('CloseAll');
catch
end
stimGenPTB('open','COM2')

%% Define stimulus
stimuli = [];
stimuli(1,:) = 1:14;
% stimuli(1,:) = 4*ones(1,14);
stimuli(2,:) = 100*ones(1,14);
for iRep = 1:10
for iChannel = 1:14
    iChannel

constructStimuli(stimuli(:,iChannel));
% pause(pauseDur);

end

end
%% Stimulate  
function constructStimuli(stimulus)
    f = stimulus(2);
    p = stimulus(1);

    stim = {...
        {'fixed',f,1,stimDur},...
        {'fixchan',p},...
        };

    [t,s]=buildTSM_nomap(stim);

    stimGenPTB('load',s,t);
    rtn=-1;
    while rtn==-1
        rtn=stimGenPTB('start');
    end
end


end
