function [ output_args ] = buildSV( stimwrd )
%Function to read in the two output files from PRAAT and output the
% data into a cell array. Input is the stimword and it assumes the two
% files stimwrdTG.csv and stimwrdF.CSV are in the current working
% directory. The output is saved as stimwrd_SV.mat
% ETA created 06/08/18
% ETA updated 06/13/18
% 
%   

stepsize = .005
TextGrid_filename= sprintf('%sTG.csv', stimwrd);
TrackedData_filename= sprintf('%sF.csv', stimwrd);
output_filename= sprintf('%s_SV', stimwrd);

%Labels

wordvoc = {'timestamp','voicing','phoneme','f1','f2','f3','intens','F0'};


% read in the TextGrid output
[num,txt,raw] = xlsread(TextGrid_filename);
[x,y] = size(raw);
fileLen = stepsize*(floor(raw{x,y}/stepsize))


vuv(:,1)=0:stepsize:fileLen


for i = 1:length(vuv)
    timestamp = (i*stepsize)-stepsize;    
    voicing = 1;
    phoneme = 'p';
    f1 = 200;
    f2 = 1000;
    f3 = 2000;
    intens = 0;
    wordvoc{i+1,1} = timestamp;
    wordvoc{i+1,2} = 0;
    wordvoc{i+1,3} = '#';
    wordvoc{i+1,4} = 0;
    wordvoc{i+1,5} = 0;
    wordvoc{i+1,6} = 0;
    wordvoc{i+1,7} = intens;
    wordvoc{i+1,8} = '--undefined--';
end


t1 = raw{3,1}
t2 = raw{3,4}
for j = 2:length(raw)
    t1 = raw{j,1}
    t2 = raw{j,4}
    indx = find((vuv>=t1&vuv<t2))

    switch raw{j,2}
        case 'vuv'
            for k = 1:length(indx)
                if raw{j,3} == 'V';
                    wordvoc{indx(k)+1,2} = 1;
                end
            end
        case 'phoneme'
            for k = 1:length(indx)
                wordvoc{indx(k)+1,3} = raw{j,3};
            end

    end        
end
% read in the Frequency output

[numf,txtf,rawf] = xlsread(TrackedData_filename);

for j = 2:length(rawf)
    t1 = rawf{j,1}
    t2 = rawf{j,1}+stepsize
    indx = find((vuv>=t1&vuv<t2))

            for k = 1:length(indx)
                    wordvoc{indx(k)+1,4} = rawf{j,4}; % F1
                    wordvoc{indx(k)+1,5} = rawf{j,5};% F2
                    wordvoc{indx(k)+1,6} = rawf{j,6};% F3
                    wordvoc{indx(k)+1,7} = rawf{j,2};% Intensity
                    wordvoc{indx(k)+1,8} = rawf{j,9};% F0
            end
end
save(output_filename,'wordvoc')
clear all;

end

