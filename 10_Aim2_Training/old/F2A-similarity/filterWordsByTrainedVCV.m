% filter word list to only include consonants that are in trained VCVs 
% and vowels that sound /a/-like

words_filtered_phlex = {};
words_filtered = {};
i_word_filt = 1;
include_word = true;

for i_word=1:length(wordsPhLex)
    include_word = true;
    for i_let = 1:length(wordsPhLex{i_word})
         if contains('tbkmvdnpfzgsac^',wordsPhLex{i_word}(i_let)), continue;
         else
             include_word = false;
             break;
         end
    end
    if include_word
       words_filtered_phlex{i_word_filt} = wordsPhLex{i_word};
       words_filtered{i_word_filt} = words{i_word};
       i_word_filt = i_word_filt + 1; 
    end
end