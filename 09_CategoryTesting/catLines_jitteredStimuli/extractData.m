% Takes the exptdesign and the trialOutput and mashes everything into
% single arrays

function outputData = extractData(exptFilename, study)

exptData = load(exptFilename);
numSessions=exptData.exptdesign.numSessions;
numTrials=exptData.exptdesign.numTrialsPerSession;
index = 1;

if strcmp(study, 'Automaticity')
	%  Go through each session
	for session = 1:length(exptData.trialOutput)
	    %  Go through each trial
	    for trial = 1:length(exptData.trialOutput(session).trials)
	
	        outputData.trialIndex(index) = exptData.trialOutput(session).trials(trial).trialIndex;
	        outputData.imagefile{index} = exptData.trialOutput(session).trials(trial).imagefile;
	        outputData.line(index) = exptData.trialOutput(session).trials(trial).line;
	        outputData.images(index) = exptData.trialOutput(session).trials(trial).images;
	        outputData.condition(index) = exptData.trialOutput(session).trials(trial).condition;
	        outputData.response(index) = exptData.trialOutput(session).trials(trial).subjectAnimalResponse;
	        outputData.RT(index)=exptData.trialOutput(session).trials(trial).AnimalResponseFinish - ...
	            exptData.trialOutput(session).trials(trial).AnimalResponseStart;
	
	        index = index + 1;
	    end
	end  
elseif strcmp(study, 'Vibrotactile')
	%  Go through each session
	for block = 1:length(exptData.trialOutput)
		for trial = 1 : length(exptData.trialOutput(block).sResp)
			outputData.stimuli(index) = exptData.trialOutput(block).stimuli(1, trial);
			
			if(mod(block, 2) == 1)
				outputData.condition(index) = exptData.trialOutput(block).correctResponse(trial);
				outputData.response(index) = exptData.trialOutput(block).sResp(trial);
			else
				outputData.condition(index) = 3 - exptData.trialOutput(block).correctResponse(trial);
				outputData.response(index) = 3 - exptData.trialOutput(block).sResp(trial);
			end
			
			index = index + 1;
		end
	end
end
end



