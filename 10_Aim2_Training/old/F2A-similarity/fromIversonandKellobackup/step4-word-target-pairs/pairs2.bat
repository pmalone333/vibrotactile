awk -f wordpair.awk f2a-lec2.txt > f2a-par2.all
awk -f prune2.awk f2a-par2.all > f2a-par2.new
