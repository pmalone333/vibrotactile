BEGIN{  i = 1
        while (getline<"foo.txt" > 0) {
                if (i == 1) print $0
                else {  head[i-1] = $1 " " $2 " " $3 " "}
                i++}}
{print head[NR] $0}
