%
% separateTextElements.m - parse text line and return cell array of 
%   separated strings (separator chars are spaces, tabs, commas, or defined)
%
% Silvio Eberhardt, 11/30/12

% process string and return separate elements
function rtn = separateTextElements(line, specialSeparator)
    % if string is in cell, extract first
    if iscell(line) == 1
        line = line{1};
    end
    len = numel(line);
    cidx = 1;
    arr = 0;    % allow processing arrays
    rtn = {};
    if exist('specialSeparator','var') == 0
        specialSeparator = ' ';
    end
    
    while cidx < len
        % eliminate all beginning spacing characters
        while cidx < len    
            c = line(cidx);
            % eliminate all initial separator characters
            if c~=' ' && c~=',' && c~=':' && c~=';' && c~='#' && c~= specialSeparator
                break;  % got next text token
            end
            cidx = cidx + 1;
        end
        % get string token        
        startidx = cidx;
        while cidx <= len
            c = line(cidx);
            if c == '['
                arr = 1;
            end
            if c == ']'
                arr=0;
            end
            
            if arr == 0 && (c==' ' || c==',' || c==':' || c==';' || c=='#' || c==specialSeparator)
                break;  % got next text token
            end
            cidx = cidx + 1;
        end            
        endidx = cidx - 1;
        % register string
        rtn = [rtn, line(startidx:endidx)];
     end
end
