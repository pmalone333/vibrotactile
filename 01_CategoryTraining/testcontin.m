try
stimGenPTB('CloseAll');
catch
end
stimGenPTB('open','COM1')
while 1
    tic;
    while toc < 2
 
    end
    s = [1,2,4,8,1,2,4,8,1,2,4,8,1,2,4,8,1,2,4,8,1,2,4,8];
    t = [50,100,155,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,1150,1200];
    r = stimGenPTB('load',s,t);
    fprintf('load returned: ');
    for i=1:numel(r)
        fprintf('%x ',r(i));
    end
    fprintf('\n');
    r = stimGenPTB('start');
    fprintf('start returned %d\n',r);
end
