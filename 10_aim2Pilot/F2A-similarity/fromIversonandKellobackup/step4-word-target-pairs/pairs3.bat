awk -f wordpair.awk f2a-lec.txt > f2a-pair.all
awk -f addsize.awk f2a-lec.txt > f2a-lec.siz
awk -f addsize2.awk f2a-pair.all | awk -f wcount.awk | sort -n +12 -13 +7 -8 > f2a-pair.siz
awk -f prune.awk f2a-pair.siz > f2a-pair.uni
