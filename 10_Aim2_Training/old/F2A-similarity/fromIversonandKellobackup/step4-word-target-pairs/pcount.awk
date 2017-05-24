{
  words[$1]++;
  words[$2]++;
  words[$3]++;
  words[$4]++;
  wline[NR] = $0;
}
END {
  for( i = 1; i <= NR; i++ ) {
    split( wline[i], arr1 );
    numother = 0;
    for( j = 1; j <= NR; j++ ) {
      if( i == j ) continue;
      split( wline[j], arr2 );
      skipit = 0;
      for( k = 1; k <= 4; k++ ) {
        for( l = 1; l <= 4; l++ )
          if( arr1[k] == arr2[l] ) { numother++; skipit = 1; break; }
        if( skipit ) break;
      }
    }
    printf( "%s\t%d\n", wline[i], numother );
  }
}
