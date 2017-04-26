type f2amat.txt >foo.txt
gawk -f makclust.awk f2aclus.txt >>foo.txt
gawk -f pcclust.awk foo.txt >>f2apc.txt
