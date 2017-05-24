stimGenPTB('open');
load('VTspeechStim')
tm = VTspeechStim{1,1};
ch = VTspeechStim{2,1};
%stimGenPTB('load',remapChan(ch),tm);
stimGenPTB('load',ch,tm);
stimGenPTB('start');