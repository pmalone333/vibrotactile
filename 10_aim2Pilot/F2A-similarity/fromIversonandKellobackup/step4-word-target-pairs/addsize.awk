{
  lecsize[$2]++;
  lecsize[$3]++;
  lecsize[$4]++;
  lline[NR] = $0;
}
END {
  for( i = 1; i <= NR; i++ ) {
    split( lline[i], arr );
    printf( "%s\t%d\t%d\t%d\t%d\n", lline[i], lecsize[arr[2]], lecsize[arr[3]], lecsize[arr[4]],
      (lecsize[arr[2]]+lecsize[arr[3]]+lecsize[arr[4]]) );
  }
}
  
