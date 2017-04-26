
audio_filename = 'audio\JohnsHopkins1986_SAL_EECS_DISC1_Side1_1vcvMale_MONO.wav';
%audio_filename = '/Volumes/MALONE/10_aim2Pilot/audio/JohnsHopkins1986_SAL_EECS_DISC1_Side1_1vcvfemaleMONO_ampNormalized_-19dB.wav';

list_startSamples = [1515568;9667712;2324376;6896944;2876928;11037080;3189240;11317360;3269320;11381424;3709760;11733776;4054104;12038080;5023072;12999040;6120168;14112152;6504552;14536576;7353400;15345384;7617664;15665704];
list_numSamples = [72072;80080;64064;88088;72072;64064;80080;56056;80080;64064;72072;64064;72072;56056;72072;64064;64064;72072;64064;72072;56056;72072;64064;72072];

list_words = {'asa';'asa';'aza';'aza';'ada';'ada';'aka';'aka';'afa';'afa';...
    'aba';'aba';'ava';'ava';'ana';'ana';'ama';'ama';'aga';'aga';'apa';...
    'apa';'ata';'ata'};

word_pairs_voicing = {{'aba','apa'},{'ada','ata'},{'ava','afa'},...
    {'aga','aka'},{'aza','asa'}};

word_pairs_place = {{'apa','ata'},{'aba','aga'},{'ava','aza'},...
    {'afa','asa'},{'ama','ana'}};

word_pairs_manner = {{'ada','aza'},{'aza','ana'},{'aba','ama'}...
    {'ada','ana'},{'ata','asa'}};
