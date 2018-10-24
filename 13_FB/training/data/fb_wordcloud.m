vocode = {'1103','1108','1112','1135','1144','1150','1154','1155','1162,','1153'};
phoneme = {'1134','1106','1137','1141','1142','1146','1145','1126','1151','1157'};

%words = {'sand','tanned','mask','teams','toads','dense','dance','most','nest','codes','notes','peaks','test','task','mend','sets','tones','tunes','peace','meat','nose','mood','moon','teak','spin','spit','stoop','speak','steam','snooze'};
%words = sort(words);
%training words in scan
words = {'sand','tanned','mask','teams','toads','dense','dance','most','nest','peace','meat','nose','spin','spit','stoop'};
incorr = zeros(length(words),1);

% for sorting words array by final constant - flip words, then sort, then
% flip back
for i=1:length(words)
   words{i} = fliplr(words{i}); 
end
words = sort(words);
for i=1:length(words)
   words{i} = fliplr(words{i}); 
end

% for s=1:length(vocode)
%     
%     fp = dir(fullfile([vocode{s} '/*block5.mat']));
%     for f=1:length(fp)
%         load([vocode{s} '/' fp(f).name]);
%         for t=1:length(trialOutput)
%            for i=1:length(trialOutput(t).target)
%                if trialOutput(t).accuracy(i) == 0
%                    incorr(ismember(words,trialOutput(t).target{i})) = incorr(ismember(words,trialOutput(t).target{i})) + 1;
%                end
%            end
%         end
%     end
%     
% end
% 
% incorr = zeros(length(words),1);
% for s=1:length(phoneme)
%     
%     fp = dir(fullfile([phoneme{s} '/*block5.mat']));
%     for f=1:length(fp)
%         load([phoneme{s} '/' fp(f).name]);
%         for t=1:length(trialOutput)
%            for i=1:length(trialOutput(t).target)
%                if trialOutput(t).accuracy(i) == 0
%                    incorr(ismember(words,trialOutput(t).target{i})) = incorr(ismember(words,trialOutput(t).target{i})) + 1;
%                end
%            end
%         end
%     end
%     
% end
% 
% wordcloud(words,incorr)



%% confusions 
algo = vocode;
conf = zeros(length(words));
total = zeros(length(words));
for s=1:length(algo)
    fp = dir(fullfile([algo{s} '/*block5.mat']));
    for f=1:length(fp)
        load([algo{s} '/' fp(f).name]);
        for t=1:length(trialOutput)
           for i=1:length(trialOutput(t).target)
                if isempty(trialOutput(t).sResp{i}), continue; end
                if isempty(strfind('123456790',trialOutput(t).sResp{i}(1))), continue; end
                if str2num(trialOutput(t).sResp{i}(1)) == 0
                    idx = 10;
                else
                    idx = str2num(trialOutput(t).sResp{i}(1));
                end
                try
                conf(ismember(words,trialOutput(t).target{i}),ismember(words,trialOutput(t).disp_labels{i}{idx})) = conf(ismember(words,trialOutput(t).target{i}),ismember(words,trialOutput(t).disp_labels{i}{idx})) + 1; 
                for x=1:length(trialOutput(t).disp_labels{i})
                    total(ismember(words,trialOutput(t).target{i}),ismember(words,trialOutput(t).disp_labels{i}{x})) = conf(ismember(words,trialOutput(t).target{i}),ismember(words,trialOutput(t).disp_labels{i}{x})) + 1; 
                end
                catch
                end
           end
        end
    end
end
conf(1:1+size(conf,1):end) = 0;
conf = conf+conf'; %add transpose to make matrix symmetrical 
total = total+total';
conf = conf./total;
conf(1:1+size(conf,1):end) = 1;
conf = 1-conf;
imagesc(conf);
xticklabels(words);
xticks([1:30]);
yticklabels(words);
yticks([1:30]);
xtickangle(90);

y = squareform(conf);
Z = linkage(y,'complete');
[h,t,outperm]=dendrogram(Z,'ColorThreshold',0.2);
H = dendrogram(Z,'ColorThreshold',.2,'Labels',words,'Orientation','left');
xtickangle(90);
set(H,'LineWidth',1)
  