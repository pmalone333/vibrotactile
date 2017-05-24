{
  numword[$1]++; 
  numword[$2]++; 
  numword[$3]++; 
  numword[$4]++; 
  wline[NR] = $0;
}
END {
  for( i = 1; i <= NR; i++ ) {
    split( wline[i], arr );
    printf( "%s\t%d\t%d\t%d\t%d\t%d\n", wline[i], numword[arr[1]], numword[arr[2]], numword[arr[3]], 
      numword[arr[4]], (numword[arr[1]]+numword[arr[2]]+numword[arr[3]]+numword[arr[4]]) );
  }
}
