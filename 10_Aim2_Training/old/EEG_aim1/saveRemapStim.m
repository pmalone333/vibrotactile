vcv_stim = {'aba1','aba2','ada1','ada2','afa1','afa2', ... 
    'aga1','aga2','aka1','aka2','ama1','ama2','ana1','ana2', ...
    'apa1','apa2','asa1','asa2','ata1','ata2','ava1','ava2', ...
    'aza1','aza2'};

for s=1:length(vcv_stim)
   load([vcv_stim{s} '.mat']);
   tm = tactStim{1}{1}; % unpack the information from the sampled files
   ch = tactStim{1}{2};
   ch = remapChan(ch);
   save([vcv_stim{s} '_remapChan'],'ch','tm')
   clear tm ch
end