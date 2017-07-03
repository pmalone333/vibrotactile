%
function xypoints = vibplot(file, timeoffset)
if exist('timeoffset','var') == 0
    timeoffset = 0.0;
end

lookupf = [150.0,300.0,450.0,600.0,750.0,900.0,1050.0,1200.0,1350.0,1500.0,1650.0,1800.0,3115.0,3565.0];
map = [8,4,6,2,11,13,9,7,3,5,1,12,14,10];
load(file);
timepoints = tactStim{1}{1};
channels = tactStim{1}{2};

xypoints = zeros(2000,2);
numOut = 0;
numSamps = numel(timepoints);

for i = 1:numSamps
    tm = timeoffset + (double(timepoints(i))/1000.0);
    chan = channels(i);
    for b=1:14
        bt = map(b);
        if bitget(chan,bt) == 1
            numOut = numOut + 1;
            xypoints(numOut,1) = tm;
            xypoints(numOut,2) = lookupf(b);
        end
    end
end

xypoints = xypoints(1:numOut,:);
end % function
