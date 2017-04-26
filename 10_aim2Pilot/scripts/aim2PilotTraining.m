load('vcvVowelIndices');

% load audio
audio_filename_vcv = 'I:\JohnsHopkins1986_SAL_EECS_DISC1_Side1_1vcvfemaleMONO.wav';
audio_filename_vowel = 'I:\JohnsHopkins1986_SAL_EECS_DISC1_Side1vowelsFemaleMONO.wav';
[y_vcv, freq_vcv, ~] = wavread(audio_filename);
wavedata_vcv = y_vcv';
nrchannels_vcv = size(wavedata_vcv,1);
InitializePsychSound;
soundhandle_vcv = PsychPortAudio('Open', [], [], 0, freq_vcv, nrchannels_vcv);

% fill primary buffer with waveform... tokens will be copied from this
PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);  