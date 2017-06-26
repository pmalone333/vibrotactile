%words_cfg;
vcv_cfg_old;

%load audio
[y,freq] = audioread(audio_filename);
wavedata = y';
nrchannels = size(wavedata,1);
InitializePsychSound;
soundhandle = PsychPortAudio('Open', [], [], 0, freq, nrchannels);

%fill primary buffer with waveform... tokens will be copied from this
PsychPortAudio('FillBuffer', soundhandle, wavedata, 0, 1);

for i=1:length(list_words)
   startSamp = list_startSamples(i);
   numSamps = list_numSamples(i); 
   
   awave = wavedata(1, startSamp:startSamp+numSamps);
   PsychPortAudio('FillBuffer', soundhandle, awave);
   
   %start audio, wait for it to finish
   PsychPortAudio('Start', soundhandle, 1,0,1);
   while 1
       status = PsychPortAudio('GetStatus', soundhandle);
       %wait for playback to finish
       if status.Active == 0
           break;
       end
   end
   pause(12)
end