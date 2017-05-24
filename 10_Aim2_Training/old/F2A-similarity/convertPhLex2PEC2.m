load('D1S2MRT.mat');

wordsPECs = cell(length(words_filtered_phlex),1);

for i_word=1:length(words_filtered_phlex)
   for i_let = 1:length(words_filtered_phlex{i_word})
       if contains('kg',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'kg'];
       elseif contains('td',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'td'];
       elseif contains('ma',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'ma'];
       elseif contains('pbfvTDszh',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'pbfvTDszh'];
       elseif contains('w',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'w'];
       elseif contains('rl',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'rl'];
       elseif contains('n',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'n'];
       elseif contains('CjsZ',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'CjsZ'];
       elseif contains('U',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}= [wordsPECs{i_word} 'U'];
       elseif contains('ou',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'ou'];
       elseif contains('I',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'I'];
       elseif contains('E@',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'E@'];
       elseif contains('W',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'W'];
       elseif contains('ac^',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'ac^'];
       elseif contains('i',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'i'];
       elseif contains('e',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'e'];
       elseif contains('O',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'O'];
       elseif contains('A',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'A'];
       elseif contains('R',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'R'];
       elseif contains('G',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'G']; % important: this phoneme (ng as in sing) was not used in Iverson 1996, so we don't know what PEC it belongs to
       elseif contains('S',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word} = [wordsPECs{i_word} 'S']; % important: this phoneme (sh as in shin) was not used in Iverson 1996, so we don't know what PEC it belongs to 
       end
   end
end