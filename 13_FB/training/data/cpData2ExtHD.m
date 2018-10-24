%subs = {'1103','1108','1112','1135','1144','1150','1154','1155','1162,','1153','1134','1106','1137','1141','1142','1146','1145','1126','1151','1157'};
subs = {'1162'};
for s=1:length(subs)
    fp = dir(fullfile([subs{s} '/*block*.mat']));
    
    for f=1:length(fp)
        load([subs{s} '/' fp(f).name]);
        
        % training AFC or testing 10 AFC 
        if isfield(trialOutput,'disp_str')
            if size(trialOutput(1).labels,2) == 10 %testing 10 AFC
                mkdir(['/Volumes/maloneHD/Data/FB/behavData/testing/10afc/MR' subs{s} '/'])
                copyfile([subs{s} '/' fp(f).name],['/Volumes/maloneHD/Data/FB/behavData/testing/10afc/MR' subs{s} '/'])
            else
%                 mkdir(['/Volumes/maloneHD/Data/FB/behavData/training/afc/MR' subs{s} '/'])
%                 copyfile([subs{s} '/' fp(f).name],['/Volumes/maloneHD/Data/FB/behavData/training/afc/MR' subs{s} '/'])
            end
            
        elseif isfield(trialOutput,'confResp')
%             for i=1:length(trialOutput(1).target)
%                if strcmp(trialOutput(1).target{i},'notes') %training word
%                     mkdir(['/Volumes/maloneHD/Data/FB/behavData/training/opensetID/MR' subs{s} '/']);
%                     copyfile([subs{s} '/' fp(f).name],['/Volumes/maloneHD/Data/FB/behavData/training/opensetID/MR' subs{s} '/'])
%                elseif strcmp(trialOutput(1).target{i},'soak') %generalization word 
%                    mkdir(['/Volumes/maloneHD/Data/FB/behavData/testing/opensetID/MR' subs{s} '/']);
%                    copyfile([subs{s} '/' fp(f).name],['/Volumes/maloneHD/Data/FB/behavData/testing/opensetID/MR' subs{s} '/'])
%                end
%             end
        end
    end
end
    