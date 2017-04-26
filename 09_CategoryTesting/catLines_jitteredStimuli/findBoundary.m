% decide the boundary based on the fitted parameters

function bound=findBoundary(paras, steps)
curMin=1000.0;
curB = 0;
for i=1:0.2:size(steps,2)
    curV = paras(1)/(1+exp(-(paras(2)-i)/paras(3)))+paras(4);
%    disp(curV);
    if abs(curV-50.0) < curMin
        curMin = abs(curV-50.0);
        curB = i;
    end
end
bound = curB;