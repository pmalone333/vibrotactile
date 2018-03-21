vocode = {'1103','1108','1112','1135','1144','1150','1154','1155','1162,','1153'};
phoneme = {'1134','1106','1137','1141','1142','1146','1145','1126','1151'};

words = {'sand','tanned','mask','teams','toads','dense','dance','most','nest','codes','notes','peaks','test','task','mend','sets','tones','tunes','peace','meat','nose','mood','moon','teak','spin','spit','stoop','speak','steam','snooze'};
incorr = zeros(length(words),1);

for s=1:length(vocode)
    
    fp = dir(fullfile([vocode{s} '/*block5.mat']));
    for f=1:length(fp)
        load([vocode{s} '/' fp(f).name]);
        for t=1:length(trialOutput)
           for i=1:length(trialOutput(t).target)
               if trialOutput(t).accuracy(i) == 0
                   incorr(ismember(words,trialOutput(t).target{i})) = incorr(ismember(words,trialOutput(t).target{i})) + 1;
               end
           end
        end
    end
    
end

incorr = zeros(length(words),1);
for s=1:length(phoneme)
    
    fp = dir(fullfile([phoneme{s} '/*block5.mat']));
    for f=1:length(fp)
        load([phoneme{s} '/' fp(f).name]);
        for t=1:length(trialOutput)
           for i=1:length(trialOutput(t).target)
               if trialOutput(t).accuracy(i) == 0
                   incorr(ismember(words,trialOutput(t).target{i})) = incorr(ismember(words,trialOutput(t).target{i})) + 1;
               end
           end
        end
    end
    
end

wordcloud(words,incorr)



%% confusions 

conf_word = 'task';
conf = [];
for s=1:length(vocode)
    
    fp = dir(fullfile([vocode{s} '/*block5.mat']));
    for f=1:length(fp)
        load([vocode{s} '/' fp(f).name]);
        for t=1:length(trialOutput)
           for i=1:length(trialOutput(t).target)
               if strcmp(conf_word,trialOutput(t).target{i})
                   conf(ismember(words,trialOutput(t).target{i})) = incorr(ismember(words,trialOutput(t).target{i})) + 1;
               end
           end
        end
    end
    
end