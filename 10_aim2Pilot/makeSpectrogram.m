vcv_cfg_old;

window = hamming(512); % window size of 512 points
noverlap = 256; % number of points for repeating window 
nfft=1024; % size of fft
%lookupf = [825,975,1125,1275,1425,1575,1725,1875,2025,2175,2325,2475,2625,3115]; % freqs for F2 vocoder algorithm
lookupf = [260,392,525,660,791,925,1060,1225,1390,1590,1820,2080,2380,5000]; % freqs for GUEq vocoder algorithm 
% offsets = [.28 .45 .135 .685 .275 .155 .445 .095 .43 .046 .33 .14 .32 .035 .395 .12 ...
%    .17 .225 .19 .35 .145 .42 .1 .275]; % time offsets for beginning of vcv stimuli, found by manual inspection of spectrogram and waveform
offsets = [.032 .03 .04 .012 .016 .01 .012 .015 .012 .02 .03 .022 .015 .022 .02 .025 ...
   .02 .028 .034 .05 0 .02 .05 .045];
first_vowel_offset = [.265 .265 .29 .265 .22 .24 .235 .195 .22 .22 .28 .28 .28 .245 .195 .19 .25 .285 .225 .265 .225 .24 .215 .225];
second_vowel_onset = [.475 .505 .515 .52 .46 .47 .495 .44 .455 .41 .455 .445 .495 .412 .495 .53 .45 .49 .47 .575 .475 .495 .47 .5];
% consonant_onset = [.535 .73 .42 .98 .51 .455 .823 .443 .675 .29 .595 .41 .64 .27 .63 .35 ... 
%                    .41 .49 .45 .64 .51 .8 .42 .63]; % onset of C of VCV, found by manual inspection of spectrogram and waveform 
% first_vowel_offset = [.51 .695 .395 .92 .5 .45 .68 .285 .615 .235 .585 .39 .595 .245 .61 .33 .4 .47 .42 .61 .36 .655 .295 0.5];
% consonant_release = [.72 .93 .6 1.15 .66 .565 .823 .443 .865 .435 .75 .55 .79 .415 .8 .55 .595 .665 0.555 .78 .51 .8 .42 .63];
% second_vowel_onset = [.72 .93 .6 1.15 .685 .595 .925 .52 .865 .435 .75 .55 .79 .415 .8 .55 .595 .665 0.555 .78 .585 .875 .495 .715];
%found by manual inspection of the spectrum; corresponds entry-by-entry to
%list_words
volAndGainSettings = 'outputgain45_200Hz_GUeq_FFTfiltered';
volAndGainSettingsFileName = 'outputgain45_200Hz_GUeq_FFTfiltered';

for i=1%:2:length(list_words)
    
        audio_filename = ['audio\VCV_male\' list_words{i} '1_ampNorm__ampNorm_audition_FFTfilter.wav'];    
        %load audio
        [y,fs] = audioread(audio_filename);
        wavedata = y';
        vcv_label1 = ['sampledPulseFiles\VCVs_maleTalker_ampNorm\' volAndGainSettings '\' list_words{i} '1'];
        vcv_plot1 = vibplot(vcv_label1,offsets(i));

        subplot(2,1,1);
        [S,F,T,P] = spectrogram(wavedata,window,noverlap,nfft,fs,'yaxis');
        surf(T,F,10*log10(P),'edgecolor','none'); axis tight; view(0,90);
        colormap(hot);
        set(gca,'clim',[-80 -30]);
        set(gca,'ylim',[0 8000]);
        xlabel('time (s)'); ylabel = ('Hz');
        y1=get(gca,'ylim');
        hold on
%         plot([first_vowel_offset(i)-.1 first_vowel_offset(i)-.1],y1)
%         plot([second_vowel_onset(i)+.15 second_vowel_onset(i)+.15],y1)
 
         hold on;
%         subplot(2,2,2);
%         t=[1/fs:1/fs:length(awave1)/fs];
%         plot(t,awave1)
        scatter(vcv_plot1(:,1),vcv_plot1(:,2),10,'o','w')
        for h=1:length(lookupf)
           hline = refline([0 lookupf(h)]);
           hline.Color = 'w';
        end
        title([list_words{i} '1 - ' volAndGainSettings]);
        
        audio_filename = ['audio\VCV_male\' list_words{i} '2_ampNorm__ampNorm_audition_FFTfilter.wav'];    
        %load audio
        [y,fs] = audioread(audio_filename);
        wavedata = y';
        
        vcv_label2 = ['sampledPulseFiles\VCVs_maleTalker_ampNorm\' volAndGainSettings '\' list_words{i} '2'];
        vcv_plot2 = vibplot(vcv_label2,offsets(i+1));

        subplot(2,1,2);
        [S2,F2,T2,P2] = spectrogram(wavedata,window,noverlap,nfft,fs,'yaxis');
        surf(T2,F2,10*log10(P2),'edgecolor','none'); axis tight; view(0,90);
        colormap(hot);
        set(gca,'clim',[-80 -30]);
        set(gca,'ylim',[0 8000]);
        xlabel('time (s)'); ylabel = ('Hz');
        y1=get(gca,'ylim');
        hold on
%         plot([first_vowel_offset(i+1)-.1 first_vowel_offset(i+1)-.1],y1)
%         plot([second_vowel_onset(i+1)+.15 second_vowel_onset(i+1)+.15],y1)
        hold on;
%         subplot(2,2,4);
%         t=[1/fs:1/fs:length(awave2)/fs];
%         plot(t,awave2)
        scatter(vcv_plot2(:,1),vcv_plot2(:,2),10,'o','c')
        for h=1:length(lookupf)
           hline = refline([0 lookupf(h)]);
        end
        title([list_words{i} '2 - ' volAndGainSettings]);
        set(gcf, 'PaperUnits', 'inches');
        x_width=7;y_width=11;
        set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
        %export_fig(gcf,[list_words{i} '_' volAndGainSettingsFileName])
        %saveas(gcf,[list_words{i} '_' volAndGainSettingsFileName '.pdf'])
        %close all
        
        clear wavedata S F T P S2 F2 T2 P2 vcv_plot1 vcv_plot2 startSamp1 startSamp2 numSamps1 numSamps2
end