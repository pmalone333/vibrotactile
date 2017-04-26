f1=2.^([0:.1:2]+log2(25));

response = input('\n\nEnter Response Profile: \n\n','s');
frequency = [f1(2) f1(8) f1(14) f1(20)];

%generate positions based on response profile 
if response == '0'
    channels = [3 5 7 11];
else
    channels = [4 6 10 12];
end

%generate frequencies to be compared with all possible positions
pair1 = [repmat(frequency(1),1,4);
         repmat(channels,1,1)];
     
pair2 = [repmat(frequency(2),1,4);
         repmat(channels,1,1)];
     
pair3 = [repmat(frequency(3),1,4);
         repmat(channels,1,1)];
     
pair4 = [repmat(frequency(4),1,4);
         repmat(channels,1,1)];
  
%generate same and different stimuli 
stimuliSame = [repmat(pair1,1,3), repmat(pair4,1,3), repmat(pair2,1,2), repmat(pair3,1,2); 
               repmat(pair1,1,3), repmat(pair4,1,3), repmat(pair2,1,2), repmat(pair3,1,2)];

stimuliDifferent = [repmat(pair2,1,3),   repmat(pair3,1,3),   repmat(pair1,1,2), repmat(pair4,1,2);
                    pair1, pair3, pair4, pair1, pair2, pair4, pair2, pair3,      pair2, pair3];
                
stimuli = [stimuliSame, stimuliDifferent];
stimuli = repmat(stimuli,1,2);

% populate trial structure with 2 instances of the same stimulus
if response == '0'
    save ('frequencyDiscrimStimuli_0.mat','stimuli')
else
    save ('frequencyDiscrimStimuli_1.mat','stimuli')
end