%
% print queued cgars from Gen2 box
%
function getQueue()
    global SportH;
    
    n = SportH.BytesAvailable;
    if n==0
        return;
    end
    fprintf('%d Bytes Available: [',n);
    rtn = fread(SportH, n, 'uint8');
    for i=1:n
        fprintf('%d ',rtn(i));
    end
    fprintf(']\n');
end
