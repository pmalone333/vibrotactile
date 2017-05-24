{
  word[NR] = $1;
  exclusive[NR] = $2;
  viseme[NR] = $3;
  inclusive[NR] = $4;
}
END {
  badpair = 0;
  for( target = 1; target <= NR; target++ ) 
    for( excnum = 1; excnum <= NR; excnum++ ) {
      if( excnum == target ) continue;
      if( exclusive[target] == exclusive[excnum] ) 
        for( visnum = 1; visnum <= NR; visnum++ ) {
          if( (visnum == target) || (visnum == excnum) ) continue;
          if( viseme[target] == viseme[visnum] ) {
            if( exclusive[target] == exclusive[visnum] ) badpair = 1;
            for( incnum = 1; incnum <= NR; incnum++ ) {
              if( (incnum == target) || (incnum == excnum) || (incnum == visnum) ) continue;
              if( inclusive[target] == inclusive[incnum] ) {
                if( (exclusive[target] == exclusive[incnum]) || (viseme[target] == viseme[incnum]) ) badpair = 1;
                if( !badpair ) printf( "%s\t%s\t%s\t%s\n", 
                  word[target], word[excnum], word[visnum], word[incnum] );
                badpair = 0;
	      }
	    }
	  }
	}
    }
}
