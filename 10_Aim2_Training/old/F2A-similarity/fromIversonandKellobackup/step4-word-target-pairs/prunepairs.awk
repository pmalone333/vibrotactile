BEGIN{usedwords = "."}
{flag = 0
for (i=2;i<=NF;i++) {
        tempstr = "." $i "."
        if (index(usedwords,tempstr) > 0) flag = 1}
if (flag==0) {
        tempstr = ""
        for (i=2;i<=NF;i++) tempstr = tempstr $i "\t"
        print tempstr
        gsub("\\t",".",tempstr)
        usedwords = usedwords tempstr}}
