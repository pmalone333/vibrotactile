type f1avmat.txt >foo.txt
gawk -f makclust.awk f1avclus.txt >>foo.txt
gawk -f pcclust.awk foo.txt >>f1avpc.txt
