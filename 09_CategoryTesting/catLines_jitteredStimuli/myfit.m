%to calculate the errors

function sse=myfit(initvalues, steps, resp)
a=initvalues(1);
b=initvalues(2);
t=initvalues(3);
e=initvalues(4);
mycurve = a./(1+exp(-(b-steps)/t))+e;
myerrors = mycurve - resp;
sse=sum(myerrors.^2);
