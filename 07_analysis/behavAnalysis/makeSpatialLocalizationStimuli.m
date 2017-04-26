f1=2.^([0:.1:2]+log2(25));

frequency = [f1(2) f1(20)];

<<<<<<< HEAD
channels = [1 3 5 9; 5 9 11 13];

%channels = [2 4 6 10; 6 10 12 14];
pair1 = [repmat(channels(1),1,4), repmat(channels(2),1,4), repmat(channels(3),1,4), repmat(channels(4),1,4), repmat(channels(2,3),1,4), repmat(channels(2,4),1,4),...
         repmat(channels(1),1,4), repmat(channels(2),1,4), repmat(channels(3),1,4), repmat(channels(4),1,4), repmat(channels(2,3),1,4), repmat(channels(2,4),1,4);
         repmat(frequency(1),1,24), repmat(frequency(2),1,24)];
         
pair2 = [repmat(channels(1,:),1,3), repmat(channels(2,:),1,3),...
         repmat(channels(1,:),1,3), repmat(channels(2,:),1,3);
         repmat(frequency(1),1,24), repmat(frequency(2),1,24)];   
pair3 = [repmat(channels(1,:),1,4), repmat(channels(2,3:4),1,4) ; repmat(frequency(1),1,8), repmat(frequency(2),1,8), repmat(frequency(1),1,4), repmat(frequency(2),1,4);
         repmat(channels(1,:),1,4), repmat(channels(2,3:4),1,4) ; repmat(frequency(1),1,8), repmat(frequency(2),1,8), repmat(frequency(1),1,4), repmat(frequency(2),1,4)];
    
%combine frequency combinations with position pairs 
stimuli = [pair1; pair2];
stimuli = [stimuli,pair3];
stimuli = [repmat(stimuli,1,2)]; 

% populate trial structure with 2 instances of the same stimulus
save ('spatialLocalizationStimuli_0.mat','stimuli')

%save ('spatialLocalizationStimuli_1.mat','stimuli')
=======
response = input('\n\nEnter Response Profile: \n\n','s');

if response == 0
    channels = [1 1 3 3 3 5 5 5 5 13 13 11 11 11 9 9 9 9; 
                3 5 5 1 9 1 3 9 11 9 11 9 13 5 13 11 5 3];
else        
    channels = [2 2 4 4 4 6 6 6 6 14 14 12 12 12 10 10 10 10;
                4 6 6 10 2 2 4 10 12 12 10 14 10 6 14 12 6 4];
end

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

if response == 0
    % populate trial structure with 2 instances of the same stimulus
    save ('spatialLocalizationStimuli_0.mat','stimuli')
else
    save ('spatialLocalizationStimuli_1.mat','stimuli')
end
>>>>>>> 981c1bcdab32eda5665c547c2465229f71bd4cf4
