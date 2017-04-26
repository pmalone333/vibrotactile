function catLines_jitteredStimuli(filename, saveDataPath, iSub, filenum, aim, study)
    %e.g. filename='s895_20150515.6140.mat';
    outputData=extractData(filename, study);
    %%
	cfg = config_subjects_VT;   
	response = zeros(size(outputData.condition));

	if strcmp(study, 'Automaticity')
		for i=1:length(outputData.condition)
			if outputData.condition(i)==1 && outputData.response(i)==1
				response(i)=0;
			elseif outputData.condition(i)==1 && outputData.response(i)==2
				response(i)=1;
			elseif outputData.condition(i)==2 && outputData.response(i)==2
				response(i)=0;
			else
				response(i)=1;
			end
		end
	elseif strcmp(study, 'Vibrotactile')
		for i = 1 : length(outputData.response)
			if outputData.response(i) == 1
				response(i) = 1;
			end
		end
	end

    %%
	
	if strcmp(study, 'Automaticity')
		for i=1:4
			for j=1:21
	            ll=(j-1)*10;
	            ul=(j-1)*10+11;
	            a=find(outputData.line==i & outputData.images>ll & outputData.images<ul);
	            catLine(i,j)=sum(response(a))./length(a);
			end
		end
	elseif strcmp(study, 'Vibrotactile')
		frequencyList = [25, 27, 29, 31, 33, 35, 38, 41, 44, 57, 62, 66, 71, 76, 81, 87, 93, 100];
        %frequencyList = [25, 27, 29, 31, 33, 35, 38, 41, 62, 66, 71, 76, 81, 87, 93, 100];
		
		for j=1:length(frequencyList)
            a=find(round(outputData.stimuli) == frequencyList(j));
            catLine(1,j)=sum(response(a))./length(a);
		end
	end

    %%
	if strcmp(study, 'Automaticity')
	    steps = 1:21;
	elseif strcmp(study, 'Vibrotactile')
		steps = [1 2 3 4 5 6 7 8 9 13 14 15 16 17 18 19 20 21];
        %steps = [1 2 3 4 5 6 7 8 14 15 16 17 18 19 20 21];
	end
	
    initvalues=[100.0, 11.0, 1.0, 0.0];

    options=optimset('Display','off');
   
    resp=catLine.*10;

	if strcmp(study, 'Automaticity')
		five=mean(resp(1:2,:),1);
	    six=mean(resp(3:4,:),1);
	    seven=mean(resp,1);
	    resp=[resp; five; six; seven];
	end
	
    resp=resp*10;
    numMorphlines = size(resp, 1);

	for j=1:numMorphlines
        estimate_subjs(j,:)=fminsearch(@myfit,initvalues, options, steps, resp(j,:));    
        estimate_boundary(j) = findBoundary(squeeze(estimate_subjs(j,:)), steps);
	end

	screenSize = get(groot,'ScreenSize');
    figure('Name', num2str(iSub), 'Position',[1, screenSize(4), screenSize(3), screenSize(4)])
	
	if strcmp(study, 'Automaticity')
		catLineNames = ['f0t5  '; 'f13t5 '; 'f13t11'; 'f0t11 '];
	    subPlotRows = 2;
		subPlotCols = 2;
	elseif strcmp(study, 'Vibrotactile')
		catLineNames = [' '; ' '; ' '; ' '];
		subPlotRows = 1;
		subPlotCols = 1;
	end
	
	for i = 1 : subPlotRows * subPlotCols
        subplot(subPlotRows,subPlotCols,i);
        %xlim=([1 21]);
        %ylim=([0 100]);
        H1 = plot(steps, resp(i,:));
		AX = gca;
        hold on;
		title(['Subject ' num2str(iSub) ' Line ' catLineNames(i, :)])
        set(H1, 'color', 'k', 'Marker', '+', 'MarkerSize', 12)
        set(get(AX,'Ylabel'),'String','Category A judgements (%)') 
        xlabel('B Morphs (%)')
        xlim(AX,[1 21]);
        ylim(AX,[-5 105]);


        xlim([1 21])
        %ylim([0 100])
        clear myc;
        clear a b t e;

        a=estimate_subjs(i,1);
        b=estimate_subjs(i,2);
        t=estimate_subjs(i,3);
        e=estimate_subjs(i,4);

        myc=a./(1+exp(-(b-steps)/t)) + e;
        plot(steps, myc,'b--', 'LineWidth', 3);
        if b > 22 || b < 0
          b = 22;
        end
        %plot([b-0.01 b+0.01], [-5 105], 'r', 'LineWidth', 3);
        %plot([11-0.01 11+0.01], [-5 105], 'k:', 'LineWidth', 1);
        plot([b b], [-5 105], 'r', 'LineWidth', 3);
        plot([11 11], [-5 105], 'k:', 'LineWidth', 1);
       % ptitle=sprintf(['Subject %d Behavioral Categorization %d to %d'], iSub, A(i), B(i));
       % title(ptitle)
        set(AX, 'XTick', 0, 'XTickLabel', {})
        set(AX, 'YTick', 0:20:100, 'XTickLabel', {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'})
		set(gca, 'XTick', 1:2:21, 'XTickLabel', {'0', '10', '20', '30', '40', '50', '60', '70', '80', '90', '100'})
		set(gca, 'YTick', 0:20:100)
        %axis=([1 21 0 100]);
        %titleA = sprintf('%d',a);
        %title=('titleA')
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		
		
		% OVERLAY GRAPHS HERE
		
		
		
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if ismember(iSub,[1028, 1034, 1040, 1043, 1058, 1062, 1064, 1072, 1073])
                sub = ['MR' num2str(iSub)];
                load(fullfile(cfg.dirs.behav_dir,sub,'MVPA_cat_post','MVPA_cat_post_inScannerBehav.mat'));
                load(fullfile(cfg.dirs.behav_dir,sub,'MVPA_cat_post','MVPA_cat_post50_50morph_inScannerBehav.mat'));
%                 scatter(2,(f26_93_acc*100),'filled','r');
%                 scatter(6,(f32_75_acc*100),'filled','r');
%                 scatter(8,(f40_61_acc*100),'filled','r');
%                 scatter(11,((numResp_catA/totalTrials)*100),'filled','r');
%                 scatter(14,((1-f61_40_acc)*100),'filled','r');
%                 scatter(16,((1-f75_32_acc)*100),'filled','r');
%                 scatter(20,((1-f93_26_acc)*100),'filled','r');    
                scatter(2,((1-f26_93_acc)*100),'filled','r');
                scatter(6,((1-f32_75_acc)*100),'filled','r');
                scatter(8,((1-f40_61_acc)*100),'filled','r');
                scatter(11,((numResp_catA/totalTrials)*100),'filled','r');
                scatter(14,(f61_40_acc*100),'filled','r');
                scatter(16,(f75_32_acc*100),'filled','r');
                scatter(20,(f93_26_acc*100),'filled','r');    

        end
		
        hold off;

	end

    save([saveDataPath '\\estimate_subjs' num2str(iSub) '_' num2str(filenum) '.mat'], 'estimate_subjs')
    saveas(gcf,['MR' num2str(iSub) '.png']);
    %saveFormats('test', ['figures\\Aim' num2str(aim) '\\catLines\\catLines_subj' num2str(iSub) '_' num2str(filenum)], saveDataPath, 300)
	close all;
end