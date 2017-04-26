{
  if( substr( $1,1,1 ) == ";" ) {
    if( NR > 1 ) printf( "\n" );
    $1 = substr( $1,2,length($1)-1 );
    printf( "%s\t%s\t%s", $1, $2, $3 );
  } else {
    printf( "\t%s", $1 );
  }
}
