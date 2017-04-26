f1=2.^([0:.1:2]+log2(25));

frequency = [f1(2) f1(20)];

channels = [1 1 3 3 3 5 5 5 5 7 7 7 7 9 9 9 11 11; 
            3 5 5 1 7 1 3 7 9 3 5 9 11 5 7 11 9 7];

different = [repmat(frequency(1),1,18), repmat(frequency(2),1,18);
             repmat(channels(1,:),1,2);
             repmat(frequency(1),1,18), repmat(frequency(2),1,18);
             repmat(channels(2,:),1,2)];

same = [repmat(frequency,1,18);
        repmat(1,1,6), repmat(3,1,6), repmat(5,1,6), repmat(9,1,6), repmat(11,1,6), repmat(13,1,6);
        repmat(frequency,1,18);
        repmat(1,1,6), repmat(3,1,6), repmat(5,1,6), repmat(9,1,6), repmat(11,1,6), repmat(13,1,6)];
    
%combine frequency combinations with position pairs 
stimuli = [different,same];
stimuli = repmat(stimuli,1,2); 

% populate trial structure with 2 instances of the same stimulus
save ('spatialLocalizationStimuli.mat','stimuli')
