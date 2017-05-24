{mat[NR "x" 1] = $1
sum = 0
for (i = 2; i <= NF; i++) {
        mat[NR "x" i] = $i
        sum += $i}
mat[NR "x" NF+1] = sum
numrow = NF-1}
END {   for (i = 1; i <= numrow; i++) {
                prnstr = ""
                for (ii = 1; ii <= numrow; ii++) {
                        val1 = mat[i "x" ii+1]
                        sum1 = mat[i "x" numrow+2]
                        val2 = mat[ii "x" i+1]
                        sum2 = mat[ii "x" numrow+2]
                        val = 1 - ((val1/sum1)+(val2/sum2))/2
                        prnstr = prnstr val " "}
                print prnstr}}
        
