BEGIN { prev = ""; }
{
  if( $4 != prev ) lec++;
  printf( "%s\t%d\n", $1, lec );
  prev = $4;
}
