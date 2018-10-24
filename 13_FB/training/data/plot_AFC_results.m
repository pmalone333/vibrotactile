% vocode = {'1103','1108','1112','1135','1144','1150','1153','1154','1155'};
% phoneme = {'1134','1106','1137','1141','1142','1146','1145','1126','1151','1157'};
vocode = {'1103','1108','1112','1135','1144','1150','1154','1155','1162,','1153'};
phoneme = {'1134','1106','1137','1141','1142','1146','1145','1126','1151','1157'};
numSessions = 6;
vocode_acc = NaN(length(vocode),numSessions);
phoneme_acc = NaN(length(phoneme),numSessions);
vocode_level = NaN(length(vocode),numSessions);
phoneme_level = NaN(length(phoneme),numSessions);


for s=1:length(vocode)
    
    fp = dir(fullfile([vocode{s} '/*block5.mat']));
    for f=1:length(fp)
        load([vocode{s} '/' fp(f).name]);
        vocode_level(s,f) = trialOutput(end).level; 
    end
    
end

for s=1:length(phoneme)
    
    fp = dir(fullfile([phoneme{s} '/*block5.mat']));
    for f=1:length(fp)
        load([phoneme{s} '/' fp(f).name]);
        phoneme_level(s,f) = trialOutput(end).level; 
    end
end


v = nanmean(vocode_level,1);
v = v(1:6);
p = nanmean(phoneme_level,1);
vs = std(vocode_level,1);
vs = nanstd(vocode_level,1);
ps = nanstd(phoneme_level,1);
vs =vs(1:6);
barwitherr([vs],[v]);
barwitherr(ps,p);