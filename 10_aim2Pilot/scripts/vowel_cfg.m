
audio_filename = 'audio\JohnsHopkins1986_SAL_EECS_DISC1_Side1vowelsFemaleMONO.wav';

list_startSamples = [1505504;2002000;3083080;2506504;3011008;...
    2106104;1633632;1881880;2730728;2226224;2346344;2810808];

list_numSamples = [128128;96096;96096;120120;64064;120120;...
    104104;120120;80080;120120;160160;96096];

list_words = {'heed';'how''d';'who''d';'hide';'hoy''d';...
    'hid';'head';'hood';'hod';'had';'haw''d';'hoed'};

word_pairs_length = {{'heed','hid'},{'how''d','head'},{'who''d','hood'},...
    {'hide','hod'},{'hoy''d','had'}};

word_pairs_H2L2 = {{'heed','who''d'},{'hid','hood'}};

word_pairs_H1L1 = {{'hod','hood'},{'had','hid'}};

word_pairs_M2L2 = {{'had','hoe''d'},{'hood','who''d'}};

word_pairs_M1L1 = {{'hoe''d','who''d'},{'head','hid'}};

word_pairs_H2M2 = {{'hod','had'},{'haw''d','head'}};

word_pairs_H1M1 = {{'hod','head'},{'had','head'}};