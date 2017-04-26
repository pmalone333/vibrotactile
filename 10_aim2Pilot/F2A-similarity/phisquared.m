%
% phisquared function for confusion matrix cluster analyses
% use in pdist and linkage
%
% A distance function specified using @: D = pdist(X,@distfun)
% A distance function must be of form d2 = distfun(XI,XJ)
% taking as arguments a 1-by-n vector XI, corresponding to a single row of X, 
% and an m2-by-n matrix XJ, corresponding to multiple rows of X. 
% distfun must accept a matrix XJ with an arbitrary number of rows. 
% distfun must return an m2-by-1 vector of distances d2, 
% whose kth element is the distance between XI and XJ(k,:).
%
% usage:
%   weuc = @(XI,XJ,W)(sqrt(bsxfun(@minus,XI,XJ).^2 * W'));
%   Dwgt = pdist(X, @(Xi,Xj) weuc(Xi,Xj,Wgts));
function d2 = phisquared(XI, XJ)
%    global grandSum;
    [nrow,ncol] = size(XJ);
    d2 = zeros(1,nrow);   % results in COLUMN VECTOR
    % calculate row sums once for efficiency
    sumI = sum(XI);
    sumJ = sum(XJ,2);
  
    for i=1:nrow % process last nr elements of XI, generating col output
        sum1 = 0;
        sum2 = 0;
        rowsums = sumI + sumJ(i); % sum of elements of both rows
        if (sumI > 0) && (sumJ(i) > 0)
            for j=1:ncol % calculate sums of squares
                % calculate expected values for this i,j
                expI = (XI(j)+XJ(i,j))/rowsums; % common part
                expJ = expI * sumJ(i);
                expI = expI * sumI;
              
                % skip if expected = 0, avoid div by zero, results should be 0?
                if (expI > 0) && (expJ > 0)
                    val = XI(j) - expI;
                    sum1 = sum1 + ((val * val)/expI);
                    val = XJ(i,j) - expJ;
                    sum2 = sum2 + ((val * val)/expJ);
                end
            end
        end
        if rowsums > 0
            d2(i) = sqrt((sum1+sum2)/rowsums);
        end
    end
end
