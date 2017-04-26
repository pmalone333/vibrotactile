%
% importConfusionMatrix - import text confusion matrix with labels  
% return (and optionally save) in CNL format (mx{1}=labels, mx{2}=data)
%
% make matrix square if it is not (if labels present)
%
% args are input name, output name, and (optionally) labels
% if output filename not supplied, then matrix just returned
% if labels are not supplied, then labels must be in input file
%
function cmx = importConfusionMatrix(infile, outfile, labels)

    cmx = {};

    % open input file
    ifile = fopen(infile, 'r');
    if ifile < 1
        fprintf('importConfusionMatrix: input file %s not found\n',infile);
        return;
    end
    
    firstline = 1;
    linenum = 0;
    labelsUsed = 0;
    curline = 1;
    
    % if labels are specified, use here to set up matrix
    % but if labels also in data, then will be replaced below
    if exist('labels', 'var') == 1
        cmx{1} = labels;  % labels given, but may be replaced below
        size = numel(labels);
        mx = zeros(size);    
    end
    
    % process each line in turn
    while 1
        writeOutput = 0;
        % get next line, break out of loop if end of file
        line = fgetl(ifile);
        if ~ischar(line)
            break;
        end
        linenum = linenum + 1;
try          
        els = separateTextElements(line);
      
        % process first line to determine whether labels are present
        if firstline == 1
            firstline = 0;
            if ischar(els{2})   % yes, have labels, so use those
                cmx{1} = els;
                size = numel(els);
                mx = zeros(size);
                labels = els;
                labelsUsed = 1;
                linenum = 0;    % reset to 0 for data line correspondence
                continue;   % done with this line
            else 
                if exists('labels','var') == 0
                    fprintf('importConfusionMatrix %s: labels not defined\n',infile);
                    return;
                end
            end
        end

        % process line of data, adding blank line if stim line missing
        if labelsUsed == 1
            % check to make sure that we have correct index (fill in lines)
            while strcmp(els{1},labels{curline}) == 0
                % assume we have to add zero line to make square
                curline = curline+1;
                if curline > size
                    % error, labels out of order
                    fprintf('importConfusionMatrix %s: stimulus labels out of order\n');
                    return;
                end
            end
            % fill in matrix
            for i=1:size
                mx(curline,i) = str2double(els{i+1});
            end
            curline = curline + 1;
        else
            % just fill in matrix
            for i=1:size
                mx(curline,i) = str2double(els{i+1});
            end
            curline = curline + 1;
        end
        
end
    end
    
    cmx{2} = mx;
    
    % write result if specified
    if exist('outfile','var')
         save(outfile, 'cmx'); 
    end
        
end


