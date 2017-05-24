type vismat.txt >foo.txt
gawk -f makclust.awk visclust.txt >>foo.txt
gawk -f pcclust.awk foo.txt >>vispc.txt
