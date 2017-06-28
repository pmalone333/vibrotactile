load('D1S2MRT.mat');

wordsPECs = cell(length(words_filtered_phlex),1);

for i_word=1:length(words_filtered_phlex)
   for i_let = 1:length(words_filtered_phlex{i_word})
       if contains('kg',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'kg';
       elseif contains('td',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'td';
       elseif contains('ma',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'ma';
       elseif contains('pbfvTDszh',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'pbfvTDszh';
       elseif contains('w',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'w';
       elseif contains('rl',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'rl';
       elseif contains('n',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'n';
       elseif contains('CjsZ',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'CjsZ';
       elseif contains('U',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'U';
       elseif contains('ou',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'ou';
       elseif contains('I',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'I';
       elseif contains('E@',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'E@';
       elseif contains('W',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'W';
       elseif contains('ac^',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'ac^';
       elseif contains('i',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'i';
       elseif contains('e',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'e';
       elseif contains('O',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'O';
       elseif contains('A',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'A';
       elseif contains('R',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'R';
       elseif contains('G',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'G'; % important: this phoneme (ng as in sing) was not used in Iverson 1996, so we don't know what PEC it belongs to
       elseif contains('S',words_filtered_phlex{i_word}(i_let)),wordsPECs{i_word}{i_let} = 'S'; % important: this phoneme (sh as in shin) was not used in Iverson 1996, so we don't know what PEC it belongs to 
       end
   end
end