vcv_cfg % load config file 

% load audio
[y, freq, ~] = wavread(audio_filename);
wavedata = y';
nrchannels = size(wavedata,1);
InitializePsychSound;
soundhandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);

% fill primary buffer with waveform... tokens will be copied from this
PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);  