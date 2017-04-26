function stimuli = makeAim1EEGstimuli()

% frequencies 
f1=2.^([0:.1:2]+log2(25));
f2=fliplr(f1);
frequency = [f1(2), f1(5) f1(8), f1(11) f1(14), f1(17) f1(20);...
             f2(2), f2(5) f2(8), f2(11) f2(14), f2(17) f2(20)];
        
% stimulator channels to be used
position = [7; 13];
position = repmat(position,1,size(frequency,2));

% label each morph as belonging to category 1 or 2 
% category 1 = lower frequency @ position closer to wrist
category(frequency(1,:)>frequency(2,:))=2;
category(frequency(1,:)<frequency(2,:))=1;

% stim IDs for EEG 
stimID = [3 4 5 6 7 8 9];
         
stimuli = [frequency; position; category; stimID];

save('aim1EEGstimuli','stimuli');
end