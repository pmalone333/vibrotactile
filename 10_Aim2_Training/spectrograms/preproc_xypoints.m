
list_words = {'asa';'asa';'aza';'aza';'ada';'ada';'aka';'aka';'afa';'afa';...
    'aba';'aba';'ava';'ava';'ana';'ana';'ama';'ama';'aga';'aga';'apa';...
    'apa';'ata';'ata'};

lookupf = [825,975,1125,1275,1425,1575,1725,1875,2025,2175,2325,2475,2625,3115];
% consonant_onset = [0.255,0.27,0.27,0.295,0.235,0.3,0.378,0.348,0.245,0.244,0.265,0.255, ... 
%     0.32,0.235,0.235,0.23,0.24,0.265,0.26,0.29,0.345,0.38,0.32,0.345]; % these onsets have the offset subtracted from them
second_vowel_onset = [.475 .505 .515 .52 .46 .47 .495 .44 .455 .41 .455 .445 .495 .412 .495 .53 .45 .49 .47 .575 .475 .495 .47 .5];
window_start = .1; % analysis window start (in s before C release)
window_stop = .1; % analysis window end (in s after C release)
volAndGainSettings = 'outputgain35';
  

for w=1:length(list_words)
   for i=1:2 % 2 tokens per VCV
       load(['sampledPulseFiles\VCVs_maleTalker_ampNorm\' volAndGainSettings '\' list_words{w} num2str(i) '_xypoints.mat']);

       xypoints(:,1) = round(xypoints(:,1),3); % round timing to nearest ms 
       vcv_length = xypoints(end,1)*1000;
       xypoints_preproc = zeros(1,14); % each column corresponds to a freq channel
       
       tm_counter = 1;
       for tm=0:vcv_length
           if tm*.001<(second_vowel_onset(w)-window_start) || tm*.001>(second_vowel_onset(w)+window_stop), continue; 
           elseif isempty(xypoints(xypoints(:,1)==(tm*.001),2)), xypoints_preproc(tm_counter,:) = 0; % no pulses at this time point, set all channels to 0 
           else
               freqs = xypoints(xypoints==(tm*.001),2);
               for f=1:length(freqs)
                    xypoints_preproc(tm_counter,find(lookupf==freqs(f))) = 1;
               end
           end
           tm_counter = tm_counter+1;  
       end
       save([list_words{w} num2str(i) '_xypoints.mat'],'xypoints','xypoints_preproc');
       clear xypoints xypoints_preproc
   end 
end