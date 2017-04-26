list_words = {'asa1';'asa2';'aza1';'aza2';'ada1';'ada2';'aka1';'aka2';'afa1';'afa2';...
    'aba1';'aba2';'ava1';'ava2';'ana1';'ana2';'ama1';'ama2';'aga1';'aga2';'apa1';...
    'apa2';'ata1';'ata2'};

offsets = [.032 .03 .04 .012 .016 .01 .012 .015 .012 .02 .03 .022 .015 .022 .02 .025 ...
   0 .028 .034 .05 0 .02 .05 .045];
first_vowel_offset = [.265 .265 .29 .265 .22 .24 .235 .195 .22 .22 .28 .28 .28 .245 .195 .19 .25 .285 .225 .265 .225 .24 .215 .225];
second_vowel_onset = [.475 .505 .515 .52 .46 .47 .495 .44 .455 .41 .455 .445 .495 .412 .495 .53 .45 .49 .47 .575 .475 .495 .47 .5];
first_vowel_window = .1; % how many seconds before first vowel offset to include
second_vowel_window = .15; % how many seconds after second vowel onset to include

for i=1:length(list_words)
    load([list_words{i} '.mat']);
    
    timepoints = tactStim{1}{1};
    timepoints = double(timepoints);
    timepoints = timepoints/4;
    channels = tactStim{1}{2};
    timepoints_chopped = [];
    channels_chopped = [];
    
    for j=1:length(timepoints)
       tm = offsets(i) + (double(timepoints(j))/1000.0);
       if tm >= (first_vowel_offset(i) - first_vowel_window) && tm <= (second_vowel_onset(i) + second_vowel_window)
           timepoints_chopped = [timepoints_chopped tactStim{1}{1}(j)];
           channels_chopped = [channels_chopped channels(j)];
       end
    end
    tactStim{1}{1} = timepoints_chopped;
    tactStim{1}{2} = channels_chopped;
    save([list_words{i} '_chopped.mat'],'tactStim');
    clear tactStim timepoints channels timepoints_chopped channels_chopped
   
    
end