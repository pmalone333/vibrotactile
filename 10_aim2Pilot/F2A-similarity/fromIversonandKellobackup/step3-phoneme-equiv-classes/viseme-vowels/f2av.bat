type f2avmat.txt >foo.txt
gawk -f makclust.awk f2avclus.txt >>foo.txt
gawk -f pcclust.awk foo.txt >>f2avpc.txt
