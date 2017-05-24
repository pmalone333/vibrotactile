BEGIN{srand()
for(i=1;i<=400;i++) {
	high[i] = ""
	vis[i] = ""
        maxvis = 0}}

{high[$2] = high[$2] $3 " "
vishnum[$3] = $2
vis[$3] = vis[$3] $1 " "
if (maxvis < $3) maxvis = $3}

END{
for(i=1;i<=maxvis;i++) {
        nvwords = split(vis[i],visarr)

        ntemp = split(high[vishnum[i]],temparr)
	tempstr = ""
	for (ii=1;ii<=ntemp;ii++)
                if (temparr[ii] != i)
                        tempstr = tempstr vis[temparr[ii]]
        nhwords = split(tempstr,higharr)

        for (g1=1;g1<=nvwords;g1++)
                for (g2=g1+1;g2<=nvwords;g2++)
                        for (g3=1;g3<=nhwords;g3++)
                                print rand() " " visarr[g1] " " visarr[g2] " " higharr[g3]
}}
			
