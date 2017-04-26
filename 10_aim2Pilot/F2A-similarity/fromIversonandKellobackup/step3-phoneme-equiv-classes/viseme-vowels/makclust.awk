{row[NR] = $0}
END{
        nphon = 0;
        for (i = 1; i <= NR; i++) {
                split(row[i],arr)
                if (arr[1] > nphon) nphon = arr[1]}
        nphon++
        cluststr = ""
        for (i = 1; i <= nphon; i++) {
                clust[i] = i
                cluststr = cluststr clust[i] " "}
        print cluststr
        for (n = 1; n < nphon; n++) {
                split(row[n],arr)
                cluststr = ""
                for (i = 1; i <= nphon; i++) {
                        if (clust[i] == arr[3]) clust[i] = arr[2]
                        cluststr = cluststr clust[i] " "}
                print cluststr}}
        
