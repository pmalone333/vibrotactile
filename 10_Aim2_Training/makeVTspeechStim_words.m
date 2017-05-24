% VTspeechStim_labels = {'ada1';'ada2';'aza1';'aza2';'aba1';'aba2';'ata1';'ata2';'ana1';'ana2';...
%     'ama1';'ama2';'asa1';'asa2';'apa1';'apa2';'ava1';'ava2';'afa1';'afa2';'aga1';...
%     'aga2';'aka1';'aka2'};

VTspeechStim_labels = {'cuff';'cub';'cup';'cuss';'suck';'puck';'pug';'buck';'bug';'pun';...
    'bun';'sun';'fun';'pus';'sub';'sup';'pub';'pup';'puff';'bus';'buff';...
    'buzz';'sud';'putt';'but';'bop';'pop';'sop'};


VTspeechStim = cell(2,28);

for i=1:length(VTspeechStim_labels)
    load([VTspeechStim_labels{i}]);
    tm = tactStim{1}{1};
    tm = tm/4; % changed because of a slower sampling rate on new pulseCapture software 
    ch = tactStim{1}{2};
    ch = remapChanVoc(ch); % mapping function from Silvio
    VTspeechStim{1,i} = tm;
    VTspeechStim{2,i} = ch;
    clear tactStim tm ch
end

save('VTspeechStim_words','VTspeechStim','VTspeechStim_labels');