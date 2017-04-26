BEGIN { numwords = 0; }
{
  already = 0;
  for( i = 1; i <= 4; i++ ) 
    if( words[$i] > 0 ) { already = 1; break; }
  if( !already ) { 
    print;
    for( i = 1; i <= 4; i++ ) words[$i]++;
  }
}
