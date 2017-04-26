function [ PhLexMap ] = LoadPhLex( LexFileName )
% LoadPhlex loads the lexicon file in and establishes the mapping between
% orthographic and phoneme transcriptions. Must be called once prior to
% calling the translation function. Returns the mapping between Orthographic and Phonemic transcription 
%   ETA 
%   Last modified 12/19/14

if exist(LexFileName, 'file')
    LexFid = fopen(LexFileName,'r');
    lex = textscan(LexFid, '%s %s %s %*[^\n]');
    fclose(LexFid);
    PhLexMap = containers.Map(lex{1,1},lex{1,3});
else 
    disp('lexicon file does not exist');
end

end

