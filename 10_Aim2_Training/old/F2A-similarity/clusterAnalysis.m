%
% calcConfusion - calculate confusion matrix parameters
%
% takes confusion matrix as input (cell array format)
% 
% SPE, 12/5/12
% Updated ETA, 3/28/16
%
function clusterAnalysis(mx, plotLabel, noFig)
    label = mx{1};
    cmx = mx{2};  % do not invert the matrix the response categories should be on x-axis for the case wise clustering of stimuli
    %cmx = mx{2}';  % must be inverted because matlab functions expect independent variable (stim tokens) on x-axis
    mxtotal = sum(sum(cmx));
    
    % calculate and save PHI distance matrix
    pdst = pdist(cmx,'@phisquared');
    %dist = squareform(pdst);
    
    % now do linkage function
    %wfn = phisquared(XI, XJ, N);
    link = linkage(cmx, 'average', '@phisquared');
    
    % calculate cophenetic correlation
    [coph, D] = cophenet(link, pdst);
    % calculate Spearman's rank correlation between dissimilarities and
    % cophenetic distances
    r = corr(pdst', D', 'type', 'spearman');

    str = '';
    if exist('plotLabel', 'var')
        str = plotLabel;
    end

    fprintf('Cluster Analysis: %s\n',str);
    fprintf('cophenetic correlation = %1.4f\nSpearman''s rank correlation = %1.4f\n',coph,r);
    
    % draw dendrogram
    if exist('noFig','var') == 0
        figure();
        [H, ~, perm] = dendrogram(link, 'colorthreshold','default','labels',label);
        set(H, 'LineWidth', 2);
        if exist('plotLabel', 'var')
            title(plotLabel);
        end
    end
    % now calculate and output the clusters based on the threshold value
    % AND number of clusters
    % start with independent clusters in the permuted order of phonemes
    num = numel(label);
    fprintf('TotalCorrect  lowestCorrectCluster, linkVal,  clusters\n');
    
    % now process from 1 cluster to individual elements
    % UPDATED The process runs from all individual to all clustered so that
    % the disance and accuracy are correctly matched with the clusters
    % This reverses the order of PEC sets from the original output
    for n=num:-1:1 
        
        % also calculate percent correct for each cluster, response for
        % cluster/clusterSum
        clusterNresp = zeros(n,1);
        clusterNstim = zeros(n,1);
        clusterPercents = zeros(n,1);
        
        % find best n clusters
        clust = cluster(link,'maxclust',n);
        
        % create string with given clusters, with newest cluster in front
        % and calculate cluster percentages:
        str = '';
        for j=1:n  % count up on cluster numbers
            for k=1:num % count up on phonemes
                if clust(k) == j % if phoneme in cluster....
                    str = strcat(str,label{k});
                    % sum all stimulus k elements
                    % updated to sum through the correct dimension of the
                    % non tranposed matrix.
                    clusterNstim(j) = clusterNstim(j) + sum(cmx(k,:));
	            %fprintf('%d\n',sum(cmx(:,k)));
                    % count up to find the responses that are within clust
                    for r=1:num % only sum if resp also in cluster
                        if clust(r) == j
                           clusterNresp(j) = clusterNresp(j) + cmx(k,r);
                        end
                    end
                end
            end
            str = strcat(str,'|');
            clusterPercents(j) = clusterNresp(j) / clusterNstim(j);
		   %fprintf('%2.3f,%d,%2.3f,%d\n',clusterNresp(j),j,clusterNstim(j),j); 
        end
        str = str(1:end-1);
        
        % get percent correct from original matrix with this clustering
        ncorrect = 0;
        for s=1:num
            for r=1:num
                if clust(s) == clust(r)
                  ncorrect = ncorrect + cmx(s,r);   
                end
            end
        end
        
        % what is minimum cluster percentage?
        minPercent = min(clusterPercents);
        
        % and print out the results
        if n ~= num
            fprintf('%2.3f, %2.3f, %1.4f, (%s)\n',ncorrect/mxtotal*100,minPercent*100,link(num-n,3),str);
        else
            fprintf('%2.3f, %2.3f, 0.0000, (%s)\n',ncorrect/mxtotal*100,minPercent*100,str);            
        end
    end
end
