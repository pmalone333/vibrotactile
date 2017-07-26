
subj = '1093';
sessDate = '20170725';
sessNum = 'sess13';

% subj: string, e.g. '945'
% sessDate: string, training session date in format YearMonthDay (e.g 20170405 for April 5 2017)

% data_path = dir(fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj, sessNum, [sessDate '*_block3.mat']));
% load(fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj,sessNum, data_path(1).name));
data_path = dir(fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj, [sessDate '*_block6.mat']));
load(fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj, data_path(1).name));


data_dir = ['data', filesep, subj, filesep, 'accTracking', filesep]; 
%make variable storing directory path 
%accTracking is folder containing voice, manner, place files  

if exist(data_dir,'dir') == 0
%if length(dir(data_dir)) < 5 %if folder is empty, make empty array containing accuracies for all 3 terms 
    mkdir(data_dir); %make new folder under subject containing tracked accuracy 
    
    voice_prev_acc = []; 
    voice_total_acc = []; 
    
    place_prev_acc = [];
    place_total_acc = []; 
    
    manner_prev_acc = [];
    manner_total_acc = []; 
else                         %directory is empty, arrays already exist, load overall data
    voice_data = load([data_dir, 'voice', subj, '.mat']);
    voice_prev_acc = voice_data.voice_overall;  
   
    place_data = load([data_dir, 'place', subj, '.mat']); 
    place_prev_acc = place_data.place_overall;
    
    manner_data = load([data_dir, 'manner', subj, '.mat']);
    manner_prev_acc = manner_data.manner_overall;
   
end  

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
voice_total = sum(voice_hits)/sum(voice_n_pres); %specific session
voice_acc_2 = [voice_acc; voice_total]; %accuracy of all VCVs plus row containg total accuracy
voice_overall =  [voice_prev_acc, voice_acc_2];   %accuracy for all sessions

place_acc = place_hits ./ place_n_pres;
place_total = sum(place_hits)/sum(place_n_pres); 
place_acc_2 = [place_acc; place_total]; %accuracy of all VCVs plus added row containing total accuracy
place_overall = [place_prev_acc, place_acc_2]; 

manner_acc = manner_hits ./ manner_n_pres;
manner_total = sum(manner_hits)/sum(manner_n_pres);
manner_acc_2 = [manner_acc; manner_total]; %accuracy of all VCVs plus added row containing total accuracy
manner_overall = [manner_prev_acc, manner_acc_2]; 

figure(1); 
subplot(3,1,1); 
bar(voice_acc_2);
xticklabels({'aba/apa','ada/ata','ava/afa','aga/aka','aza/asa','total'})
title(['sub' subj ' - voicing - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
 
subplot(3,1,2); 
bar(place_acc_2);
xticklabels({'apa/ata','aba/aga','ava/aza','afa/asa','ama/ana','total'})
title(['sub' subj ' - place - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';


subplot(3,1,3); 
bar(manner_acc_2);
xticklabels({'ada/aza','aza/ana','aba/ama','ada/ana','ata/asa', 'total'})
title(['sub' subj ' - manner - ' sessDate]);
ylim([0 1])
hline = refline([0 0.5]);
hline.Color = 'r';
saveas(gcf,fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj,[subj '_' sessDate '_all.jpg']))
%close all

%%%%articulatory features overall by VCVs%%%%%%%%%
figure(2); 
subplot(3,1,1);
hold on 
title(['sub' subj ' - voicing overtime -' sessDate])
plot (voice_overall(1,:),'b.-', 'MarkerSize', 20)
xlabel('session #')
ylabel('Accuracy')
ylim([0:1])
plot (voice_overall(2,:),'r.-', 'MarkerSize', 20)
plot (voice_overall(3,:),'k.-', 'MarkerSize', 20)
plot (voice_overall(4,:),'g.-', 'MarkerSize', 20)
plot (voice_overall(5,:),'m.-', 'MarkerSize', 20)
legend({'aba/apa','ada/ata','ava/afa','aga/aka','aza/asa'},'FontSize',8,'Location','northeastoutside')

subplot(3,1,2);
hold on
title(['sub' subj ' - place overtime -' sessDate])
plot (place_overall(1,:),'b.-','MarkerSize', 20)
xlabel('session #')
ylabel('Accuracy')
ylim([0:1])
plot (place_overall(2,:),'r.-', 'MarkerSize', 20)
plot (place_overall(3,:),'k.-', 'MarkerSize', 20)
plot (place_overall(4,:),'g.-', 'MarkerSize', 20)
plot (place_overall(5,:),'m.-', 'MarkerSize', 20)
legend({'apa/ata','aba/aga','ava/aza','afa/asa','ama/ana'},'FontSize',8,'Location','northeastoutside')

subplot(3,1,3);
hold on
title(['sub' subj ' - manner overtime-' sessDate])
plot (manner_overall(1,:),'b.-', 'MarkerSize', 20) 
xlabel('session #')
ylabel('Accuracy')
ylim([0:1])
plot (manner_overall(2,:),'r.-', 'MarkerSize', 20)
plot (manner_overall(3,:),'k.-', 'MarkerSize', 20)
plot (manner_overall(4,:),'g.-', 'MarkerSize', 20)
plot (manner_overall(5,:),'m.-', 'MarkerSize', 20)
legend({'ada/aza','aza/ana','aba/ama','ada/ana','ata/asa'},'FontSize',8,'Location','northeastoutside')
saveas(gcf,fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj, [subj '_' sessDate '_featuresOverall.jpg']))
%close all


%%%%%%articulatory features overall using total VCVs data%%%%%%%%

figure(3);
hold on 
title(['sub' subj ' - total Accuracy overtime-' sessDate])
plot (voice_overall(6,:),'b.-', 'MarkerSize', 20)
plot (place_overall(6,:),'r.-','MarkerSize', 20)
plot (manner_overall(6,:),'k.-', 'MarkerSize', 20) 
xlabel('session #')
ylabel('Accuracy')
ylim([0:1])
legend({'voice', 'place', 'manner'},'Location','northeastoutside')
saveas(gcf,fullfile('/Users/pmalone/Google Drive/Code/Vibrotactile/10_Aim2_Training/data',subj, [subj '_' sessDate '_featuresTotal.jpg']))


save([data_dir, 'voice', subj, '.mat'], 'voice_overall'); 
save([data_dir, 'place', subj, '.mat'], 'place_overall');
save([data_dir, 'manner', subj, '.mat'], 'manner_overall'); 

%overall variable becomes previous in the next run, overwritten 

