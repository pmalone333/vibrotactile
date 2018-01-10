nhits=0;
nmisses=0;
ntrials=0;
nfas=0;

for i=1:6
    tm_file_path = dir(sprintf('20*run%d.mat',i));
    if size(tm_file_path,1)>1, error('More than 1 timing file for run %d found',i_run), end
    load(tm_file_path(1).name);
    for s=1:length(trialOutput.stimuli)-2
       if isempty(trialOutput.label{s})% & isempty(trialOutput.label{s+1})
           continue
       end
       if strcmp(trialOutput.label{s},trialOutput.label{s+1})
           if trialOutput.sResp{s+2}==1
            nhits=nhits+1;
            ntrials=ntrials+1;
           else
            nmisses=nmisses+1;
            ntrials=ntrials+1;
           end
           
       else
           if trialOutput.sResp{s+2}==1
               nfas=nfas+1;
               ntrials=ntrials+1;
           else 
               ntrials=ntrials+1;
           end
       end
    end
    
end


% % count nulls
% n=0;
% for i=1:5
%     tm_file_path = dir(sprintf('20*run%d.mat',i));
%     if size(tm_file_path,1)>1, error('More than 1 timing file for run %d found',i_run), end
%     load(tm_file_path(1).name);
%     for s=1:length(trialOutput.stimuli)
%        if isempty(trialOutput.label{s})
%            n=n+1;
%        end
%     end
% end