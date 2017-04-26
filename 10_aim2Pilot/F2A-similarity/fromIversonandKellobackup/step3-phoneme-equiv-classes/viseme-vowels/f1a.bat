type f1amat.txt >foo.txt
gawk -f makclust.awk f1aclus.txt >>foo.txt
gawk -f pcclust.awk foo.txt >>f1apc.txt
