BEGIN{srand()
for(i=1;i<=400;i++) {
	high[i] = ""
	vis[i] = ""
	low[i] = ""
        maxlow = 0}}

{high[$2] = high[$2] $3 " "
vishnum[$3] = $2
vis[$3] = vis[$3] $4 " "
lowvnum[$4] = $3
low[$4] = low[$4] $1 " "
if (maxlow < $4) maxlow = $4}

END{
for(i=1;i<=maxlow;i++) {
	nlwords = split(low[i],lowarr)

	ntemp = split(vis[lowvnum[i]],temparr)
	tempstr = ""
	for (ii=1;ii<=ntemp;ii++)
                if (temparr[ii] != i)
			tempstr = tempstr low[temparr[ii]]
	nvwords = split(tempstr,visarr)

	ntemp = split(high[vishnum[lowvnum[i]]],temparr)
	tempstr = ""
	for (ii=1;ii<=ntemp;ii++)
                if (temparr[ii] != lowvnum[i])
			tempstr = tempstr vis[temparr[ii]]
	ntemp = split(tempstr,temparr)
	tempstr = ""
	for (ii=1;ii<=ntemp;ii++) tempstr = tempstr low[temparr[ii]]
	nhwords = split(tempstr,higharr)

	for (g1=1;g1<=nlwords;g1++)
		for (g2=g1+1;g2<=nlwords;g2++)
			for (g3=1;g3<=nvwords;g3++)
				for (g4=1;g4<=nhwords;g4++)
                                        print rand() " " lowarr[g1] " " lowarr[g2] " " visarr[g3] " " higharr[g4] " "
}}
			
