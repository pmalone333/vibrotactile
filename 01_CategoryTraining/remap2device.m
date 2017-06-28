function [ vectout ] = remap2device( vectin )
%remaps the targeted output channel to the actual device channel
%   Detailed explanation goes here
vectout(1:length(vectin))=0;
for i=1:length(vectin)
        if vectin(i)>0
            test=15-i;
            switch test
                case 1 
                    vectout(11)= 1;
                case 2 
                    vectout(4)= 1;
                case 3 
                    vectout(9)= 1;
                case 4 
                    vectout(2)= 1;
                case 5 
                    vectout(10)= 1;
                case 6 
                    vectout(3)= 1;
                case 7 
                    vectout(8)= 1;
                case 8 
                    vectout(1)= 1;
                case 9 
                    vectout(7)= 1;
                case 10 
                    vectout(14)= 1;
                case 11 
                    vectout(5)= 1;
                case 12 
                    vectout(12)= 1;
                case 13 
                    vectout(6)= 1;
                case 14 
                    vectout(13)= 1;
            end
        end
end

