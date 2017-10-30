words_cfg;

%load audio
[y,fs] = audioread(audio_filename);
wavedata = y';
window = hamming(512); % window size of 512 points
noverlap = 256; % number of points for repeating window 
nfft=1024; % size of fft
lookupf = [825,975,1125,1275,1425,1575,1725,1875,2025,2175,2325,2475,2625,3115]; % freqs for F2 vocoder algorithm
offsets = [.28 .45 .135 .685 .275 .155 .445 .095 .43 .046 .33 .14 .32 .035 .395 .12 ...
   .17 .225 .19 .35 .145 .42 .1 .275]; % time offsets for beginning of vcv stimuli, found by manual inspection of spectrogram and waveform
% consonant_onset = [.535 .73 .42 .98 .51 .455 .823 .443 .675 .29 .595 .41 .64 .27 .63 .35 ... 
%                    .41 .49 .45 .64 .51 .8 .42 .63]; % onset of C of VCV, found by manual inspection of spectrogram and waveform 
%found by manual inspection of the spectrum; corresponds entry-by-entry to
%list_words
volAndGainSettings = '';
volAndGainSettingsFileName = '';

for i=1:length(list_words)
        vcv_label1 = [list_words{i}];
        vcv_plot1 = vibplot(vcv_label1,offsets(i));
        startSamp1 = list_startSamples(i);
        numSamps1 = list_numSamples(i);
        
        awave1 = wavedata(1, startSamp1:startSamp1+numSamps1);
        [S,F,T,P] = spectrogram(awave1,window,noverlap,nfft,fs,'yaxis');
        surf(T,F,10*log10(P),'edgecolor','none'); axis tight; view(0,90);
        colormap(hot);
        set(gca,'clim',[-80 -30]);
        set(gca,'ylim',[0 8000]);
        set(gca,'xlim',[offsets(i)-.1 offsets(i)+.9]);
        xlabel('time (s)'); ylabel = ('Hz');
 
        hold on;
        subplot(2,2,2);
        t=[1/fs:1/fs:length(awave1)/fs];
        plot(t,awave1)
        scatter(vcv_plot1(:,1),vcv_plot1(:,2),10,'o','c')
        for h=1:length(lookupf)
           hline = refline([0 lookupf(h)]);
        end
        title([vcv_label1 ' - ' volAndGainSettings]);

        saveas(gcf,[list_words{i} '_' volAndGainSettingsFileName '.pdf'])
        close all
        
        clear awave1 awave2 S F T P S2 F2 T2 P2 vcv_plot1 vcv_plot2 startSamp1 startSamp2 numSamps1 numSamps2
end