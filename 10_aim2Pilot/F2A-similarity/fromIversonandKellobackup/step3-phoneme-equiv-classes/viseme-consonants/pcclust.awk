BEGIN { numphon = 0
        numclust = 0
        flag = 0}
{ if (NR <= NF) {
        mat[NR] = $0
        numphon = numphon + 1}
  else if (flag == 0) {
        lowcorrect = 1
        for (i = 1; i <= numphon; i++) group[i] = $i        
	  for (ln = 1; ln <= numphon; ln++) {
                right = 0
                wrong = 0
                split(mat[ln], arr)
                for (col=1; col <= numphon; col++) {
                        if (group[ln] == group[col])
                                right = right + arr[col]
                        else wrong = wrong + arr[col]}
                lncorr[ln] = right/(right+wrong)}
	  for (ln = 1; ln <= numphon; ln++) {
		numingroup = 0
		avegroup = 0
		if (group[ln] == ln) {
			for (i = 1; i <= numphon; i++) {
				if (group[i] == ln) {
					numingroup++
					avegroup += lncorr[i]}}
                        grpcorr[ln] = avegroup/numingroup
                        if (grpcorr[ln] < lowcorrect) lowcorrect = grpcorr[ln]}}
        numclust = numclust + 1
        if (lowcorrect >= 0.75) {
                for (i = 1; i <= numphon; i++) print group[i] " " grpcorr[group[i]]
                flag = 1}
        }}
