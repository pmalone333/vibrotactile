%function [stimuli] = twoptDiscrim
    f1=2.^([0:.1:2]+log2(25));
    f2=fliplr(f1);
    
    frequency = [f1(2) f1(7) f1(15) f1(20); f2(2) f2(7) f2(15) f2(20)];
    
    s1=[1:6 9:14];
    
    p = 1; % position 
    stimulator = zeros(2,44); % max number of positions combos 2*8 + 4*6 + 4
    for i=1:length(s1)
        j=0;
       if mod(s1(i),2)==0 %if even 
          while(s1(end-j)-s1(i)>2) %make sure the difference between two channels is greater than 2
             stimulator(1,p) = s1(i); %store beginning value in row 1
             stimulator(2,p) = s1(end-j); %store end value in row 2
             p = p+1;
             j = j+1;
          end
       else
          while(s1(end-j)-s1(i)>3) %make sure the difference between two channels is greater than 3
             stimulator(1,p) = s1(i); %store beginning value in row 1
             stimulator(2,p) = s1(end-j); %store end value in row 2
             p = p+1;
             j = j+1;
          end
       end   
    end
    
    %combine frequency combinations with position pairs 
    stimuli = [repmat(frequency(:,1),1,44), repmat(frequency(:,2),1,44), repmat(frequency(:,3),1,44), repmat(frequency(:,4),1,44);...
              repmat(stimulator,1,4)];
    
%     stimuli = [repmat(frequency(:,1),4,44); stimulator(:,:)];
    
   %create cells with various same/different stimuli - how do I encorporate same? As of now all different        
   p = 1;        
   for i=1:length(stimuli)
       for j = 1:(length(stimuli)-1)
           dif = 2; 
           if mod((stimuli(3,i)),2) ~= 0, dif = 3; end
               if stimuli(3,i) == stimuli(3,j) && stimuli(4,i) - stimuli(4,j) > dif && stimuli(1,i) == stimuli (1,j)
                   trialStruct{:,p} = [stimuli(:,i), stimuli(:,j)];
                   a(:,i) = stimuli(:,i);
                   b(:,j) = stimuli(:,j);
                   p = p+1;
               elseif stimuli(4,i) == stimuli(4,j) && stimuli(3,i) - stimuli(3,j) > dif && stimuli(2,i) == stimuli (2,j)
                   trialStruct{:,p} = [stimuli(:,i), stimuli(:,j)];
                   a(:,i) = stimuli(:,i);
                   b(:,j) = stimuli(:,j);
                   p = p+1;
               end
       end
    end