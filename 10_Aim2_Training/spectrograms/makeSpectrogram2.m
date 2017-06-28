vcv_cfg_old;

window = hamming(512); % window size of 512 points
noverlap = 256; % number of points for repeating window 
nfft=1024; % size of fft
lookupf = [825,975,1125,1275,1425,1575,1725,1875,2025,2175,2325,2475,2625,3115]; % freqs for F2 vocoder algorithm
offsets = [.032 .03 .04 .012 .016 .01 .012 .015 .012 .02 .03 .022 .015 .022 .02 .025 ...
   0 .028 .034 .05 0 .02 .05 .045];

volAndGainSettings = 'outputgain35';
volAndGainSettingsFileName = 'outputgain35';

for i=1:2:length(list_words)
    
        audio_filename = ['audio\VCV_male\' list_words{i} '1_ampNorm.wav'];    
        %load audio
        [y,fs] = audioread(audio_filename);
        wavedata = y';
        vcv_label1 = ['sampledPulseFiles\VCVs_maleTalker_ampNorm\' volAndGainSettings '\' list_words{i} '1.mat'];
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

        scatter(vcv_plot1(:,1),vcv_plot1(:,2),10,'o','c')
        for h=1:length(lookupf)
           hline = refline([0 lookupf(h)]);
        end
        title([list_words{i} '1 - ' volAndGainSettings]);
        
        audio_filename = ['audio\VCV_male\' list_words{i} '2_ampNorm.wav'];    
        %load audio
        [y,fs] = audioread(audio_filename);
        wavedata = y';
        
        vcv_label2 = ['sampledPulseFiles\VCVs_maleTalker_ampNorm\' volAndGainSettings '\' list_words{i} '2.mat'];
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

        scatter(vcv_plot2(:,1),vcv_plot2(:,2),10,'o','c')
        for h=1:length(lookupf)
           hline = refline([0 lookupf(h)]);
        end
        title([list_words{i} '2 - ' volAndGainSettings]);
        set(gcf, 'PaperUnits', 'inches');
        x_width=7;y_width=11;
        set(gcf, 'PaperPosition', [0 0 x_width y_width]); %
        saveas(gcf,[list_words{i} '_' volAndGainSettingsFileName '.pdf'])
        close all
        
        clear wavedata S F T P S2 F2 T2 P2 vcv_plot1 vcv_plot2 startSamp1 startSamp2 numSamps1 numSamps2
end