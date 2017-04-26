awk -f wordpair.awk f2a-lec.txt > f2a-pair.all
head -999 < f2a-pair.all | perm > t1
tail +1000 < f2a-pair.all | head -999 | perm > t2
tail +1999 < f2a-pair.all | perm > t3
cat t1 t2 t3 | awk -f prune.awk > f2a-pair.p1
head -999 < f2a-pair.all | perm > t1
tail +1000 < f2a-pair.all | head -999 | perm > t2
tail +1999 < f2a-pair.all | perm > t3
cat t2 t1 t3 | awk -f prune.awk > f2a-pair.p2
head -999 < f2a-pair.all | perm > t1
tail +1000 < f2a-pair.all | head -999 | perm > t2
tail +1999 < f2a-pair.all | perm > t3
cat t3 t2 t1 | awk -f prune.awk > f2a-pair.p3
head -999 < f2a-pair.all | perm > t1
tail +1000 < f2a-pair.all | head -999 | perm > t2
tail +1999 < f2a-pair.all | perm > t3
cat t3 t1 t2 | awk -f prune.awk > f2a-pair.p4
