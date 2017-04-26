AIM = 1;

cfg = config_subjects_VT;

%Comment out the all STUDY except the one (and only one) you want.
%STUDY = 'Automaticity';
STUDY = 'Vibrotactile';

if strcmp(STUDY, 'Automaticity')
	dataFolder = ['C:\\Users\\Jason\\Documents\\MaxLab\\Automaticity\\Data\\03_CategoryTesting\\Aim' num2str(AIM) '\\'];
	saveFolder = 'C:\\Users\\Jason\\Documents\\MaxLab\\Automaticity\\01_catLines\\';
elseif strcmp(STUDY, 'Vibrotactile')
	dataFolder = 'C:\\Users\\Patrick Malone\\Downloads\\data\\data\\';
	saveFolder = 'C:\\Users\\Patrick Malone\\Downloads\\data\\';
end

subjects = ls(dataFolder);
subjects = subjects(3:end, :);		%remove . and ..

for subject = 1 : size(subjects, 1)
	dataFiles = ls(strcat(dataFolder, subjects(subject, :)));
	dataFiles = dataFiles(3:end, :);		%remove . and ..
	
	if strcmp(STUDY, 'Vibrotactile')
		if size(dataFiles, 1) ~= 9
			continue;		%skip subjects without 6 blocks + 3 plots
			%I know that requiring the plots to be in the folder is dirty,
			%but for the sake of not having to move them I'm doing it.
		end
		
		dataFiles = dataFiles(size(dataFiles, 1) - 3, :);
			%only last block, and no plots
	end
	
	for file = 1 : size(dataFiles, 1)
		catLines_jitteredStimuli(strcat(dataFolder, subjects(subject, :), '\\', dataFiles(file, :)), saveFolder, str2num(subjects(subject, :)), file, AIM, STUDY);
	end
end