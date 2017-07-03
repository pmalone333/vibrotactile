<<<<<<< HEAD
function makeTrainingFigure(subj,sessDate)

% subj: string, e.g. '945'
% sessDate: string, training session date in format YearMonthDay (e.g 20170405 for April 5 2017)


data_path = dir(fullfile('/Users/annabianculli/Documents/Soph S2/Riesenhuber lab/vibrotactile/10_Aim2_Training/data',subj,[sessDate '*_block6.mat']));
load(fullfile('/Users/annabianculli/Documents/Soph S2/Riesenhuber lab/vibrotactile/10_Aim2_Training/data',subj,data_path(1).name));

%data_path = dir(fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,[sessDate '*_block6.mat']));
%load(fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,data_path(1).name));


voice_hits = zeros(5,1); % row 1 = aba and apa, 2 = ada and ata, 3 = ava and afa, 4 = aga and aka, 5 = aza and asa
voice_n_pres = zeros(5,1);

place_hits = zeros(5,1); % row 1 = apa and ata, 2 = aba and aga, 3 = ava and aza, 4 = afa and asa, 5 = ama and ana
place_n_pres = zeros(5,1);

manner_hits = zeros(5,1); % row 1 = ada and aza, 2 = aza and ana, 3 = aba and ama, 4 = ada and ana, 5 = ata and asa
manner_n_pres = zeros(5,1); 

for i_block=1:length(trialOutput)
    %% voicing
    if strcmp(trialOutput(i_block).feature_block,'voicing')
        for i_stim=1:length(trialOutput(i_block).stimuli)
            if strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aba') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'apa')
                voice_hits(1,1) = voice_hits(1,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(1,1) = voice_n_pres(1,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ada') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ata')
                voice_hits(2,1) = voice_hits(2,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(2,1) = voice_n_pres(2,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ava') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'afa')
                voice_hits(3,1) = voice_hits(3,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(3,1) = voice_n_pres(3,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aga') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aka')
                voice_hits(4,1) = voice_hits(4,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(4,1) = voice_n_pres(4,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aza') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'asa')
                voice_hits(5,1) = voice_hits(5,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(5,1) = voice_n_pres(5,1) + 1;
            end
        end

    
    %% place
    elseif strcmp(trialOutput(i_block).feature_block,'place')
        for i_stim=1:length(trialOutput(i_block).stimuli)
            if strcmp(trialOutput(i_block).stimuli{i_stim}(1),'apa') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ata')
                place_hits(1,1) = place_hits(1,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(1,1) = place_n_pres(1,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aba') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aga')
                place_hits(2,1) = place_hits(2,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(2,1) = place_n_pres(2,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ava') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aza')
                place_hits(3,1) = place_hits(3,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(3,1) = place_n_pres(3,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'afa') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'asa')
                place_hits(4,1) = place_hits(4,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(4,1) = place_n_pres(4,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ama') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ana')
                place_hits(5,1) = place_hits(5,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(5,1) = place_n_pres(5,1) + 1;
            end
        end
    
    %% manner
    elseif strcmp(trialOutput(i_block).feature_block,'manner')
        for i_stim=1:length(trialOutput(i_block).stimuli)
            if strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ada') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aza')
                manner_hits(1,1) = manner_hits(1,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(1,1) = manner_n_pres(1,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aza') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ana')
                manner_hits(2,1) = manner_hits(2,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(2,1) = manner_n_pres(2,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aba') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ama')
                manner_hits(3,1) = manner_hits(3,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(3,1) = manner_n_pres(3,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ada') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ana')
                manner_hits(4,1) = manner_hits(4,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(4,1) = manner_n_pres(4,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ata') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'asa')
                manner_hits(5,1) = manner_hits(5,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(5,1) = manner_n_pres(5,1) + 1;
            end
        end
    end    
end

voice_acc = voice_hits ./ voice_n_pres;
place_acc = place_hits ./ place_n_pres;
manner_acc = manner_hits ./ manner_n_pres;

bar(voice_acc);
xticklabels({'aba/apa','ada/ata','ava/afa','aga/aka','aza/asa'})
title(['sub' subj ' - voicing - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,['sub' subj '_voicing_' sessDate '.pdf']))
close all

bar(place_acc);
xticklabels({'apa/ata','aba/aga','ava/aza','afa/asa','ama/ana'})
title(['sub' subj ' - place - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,['sub' subj '_place_' sessDate '.pdf']))
close all

bar(manner_acc);
xticklabels({'ada/aza','aza/ana','aba/ama','ada/ana','ata/asa'})
title(['sub' subj ' - manner - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data\',subj,['sub' subj '_manner_' sessDate '.pdf']))

=======
function makeTrainingFigure(subj,sessDate)

% subj: string, e.g. '945'
% sessDate: string, training session date in format YearMonthDay (e.g 20170405 for April 5 2017)

data_path = dir(fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,[sessDate '*_block6.mat']));
load(fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,data_path(1).name));

voice_hits = zeros(5,1); % row 1 = aba and apa, 2 = ada and ata, 3 = ava and afa, 4 = aga and aka, 5 = aza and asa
voice_n_pres = zeros(5,1);

place_hits = zeros(5,1); % row 1 = apa and ata, 2 = aba and aga, 3 = ava and aza, 4 = afa and asa, 5 = ama and ana
place_n_pres = zeros(5,1);

manner_hits = zeros(5,1); % row 1 = ada and aza, 2 = aza and ana, 3 = aba and ama, 4 = ada and ana, 5 = ata and asa
manner_n_pres = zeros(5,1); 

for i_block=1:length(trialOutput)
    %% voicing
    if strcmp(trialOutput(i_block).feature_block,'voicing')
        for i_stim=1:length(trialOutput(i_block).stimuli)
            if strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aba') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'apa')
                voice_hits(1,1) = voice_hits(1,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(1,1) = voice_n_pres(1,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ada') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ata')
                voice_hits(2,1) = voice_hits(2,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(2,1) = voice_n_pres(2,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ava') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'afa')
                voice_hits(3,1) = voice_hits(3,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(3,1) = voice_n_pres(3,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aga') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aka')
                voice_hits(4,1) = voice_hits(4,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(4,1) = voice_n_pres(4,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aza') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'asa')
                voice_hits(5,1) = voice_hits(5,1) + trialOutput(i_block).accuracy(i_stim);
                voice_n_pres(5,1) = voice_n_pres(5,1) + 1;
            end
        end

    
    %% place
    elseif strcmp(trialOutput(i_block).feature_block,'place')
        for i_stim=1:length(trialOutput(i_block).stimuli)
            if strcmp(trialOutput(i_block).stimuli{i_stim}(1),'apa') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ata')
                place_hits(1,1) = place_hits(1,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(1,1) = place_n_pres(1,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aba') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aga')
                place_hits(2,1) = place_hits(2,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(2,1) = place_n_pres(2,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ava') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aza')
                place_hits(3,1) = place_hits(3,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(3,1) = place_n_pres(3,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'afa') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'asa')
                place_hits(4,1) = place_hits(4,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(4,1) = place_n_pres(4,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ama') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ana')
                place_hits(5,1) = place_hits(5,1) + trialOutput(i_block).accuracy(i_stim);
                place_n_pres(5,1) = place_n_pres(5,1) + 1;
            end
        end
    
    %% manner
    elseif strcmp(trialOutput(i_block).feature_block,'manner')
        for i_stim=1:length(trialOutput(i_block).stimuli)
            if strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ada') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'aza')
                manner_hits(1,1) = manner_hits(1,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(1,1) = manner_n_pres(1,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aza') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ana')
                manner_hits(2,1) = manner_hits(2,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(2,1) = manner_n_pres(2,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'aba') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ama')
                manner_hits(3,1) = manner_hits(3,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(3,1) = manner_n_pres(3,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ada') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'ana')
                manner_hits(4,1) = manner_hits(4,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(4,1) = manner_n_pres(4,1) + 1;
            elseif strcmp(trialOutput(i_block).stimuli{i_stim}(1),'ata') && strcmp(trialOutput(i_block).stimuli{i_stim}(2),'asa')
                manner_hits(5,1) = manner_hits(5,1) + trialOutput(i_block).accuracy(i_stim);
                manner_n_pres(5,1) = manner_n_pres(5,1) + 1;
            end
        end
    end    
end

voice_acc = voice_hits ./ voice_n_pres;
place_acc = place_hits ./ place_n_pres;
manner_acc = manner_hits ./ manner_n_pres;

bar(voice_acc);
xticklabels({'aba/apa','ada/ata','ava/afa','aga/aka','aza/asa'})
title(['sub' subj ' - voicing - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,['sub' subj '_voicing_' sessDate '.pdf']))
close all

bar(place_acc);
xticklabels({'apa/ata','aba/aga','ava/aza','afa/asa','ama/ana'})
title(['sub' subj ' - place - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data',subj,['sub' subj '_place_' sessDate '.pdf']))
close all

bar(manner_acc);
xticklabels({'ada/aza','aza/ana','aba/ama','ada/ana','ata/asa'})
title(['sub' subj ' - manner - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('C:\Users\Patrick Malone\Google Drive\Code\Vibrotactile\10_Aim2_Training\data\',subj,['sub' subj '_manner_' sessDate '.pdf']))

>>>>>>> 9d8cbd5b757937791c0c476e211a09eec1394d59
end