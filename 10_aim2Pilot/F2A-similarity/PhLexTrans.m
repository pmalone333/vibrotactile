function [ phonotrans ] = PhLexTrans(orthotrans)
%PhLexTrans looks up the orthographic entry orthotrans in map and
% returns the phonological transcription if it exists otherwise the string
% 99999 is returned
%   ETA 12/19/14
global PhLexMap;
lexfile='inphlex2k';

    % any double apostrophes go to single - THIS DOES NOT WORK
%     a2 = '''''';
%     a1 = '''';
%     orthotrans = regexprep(orthotrans,a2,a1); % strrep same!
    if isempty(PhLexMap)
        PhLexMap = LoadPhlex(lexfile);
        orth = upper(orthotrans);
        if isKey(PhLexMap, orth)
            phonotrans = PhLexMap(orth);
        else
            phonotrans = '99999';
        end
    else
        orth = upper(orthotrans);
%        disp('phlexmap is in mem');
        if isKey(PhLexMap, orth)
            phonotrans = PhLexMap(orth);
        else
            phonotrans = '99999';
        end
    end   
end
