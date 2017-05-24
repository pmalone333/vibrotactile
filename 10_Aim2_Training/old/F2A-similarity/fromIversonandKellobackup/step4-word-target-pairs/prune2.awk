BEGIN {
  while( getline<"oldpairs.txt" > 0 ) 
    for( i = 1; i <= NF; i++ ) 
      oldwords[$i]++; 
}
{
  nogood = 0;
  for( j = 1; j <= 4; j++ ) 
    if( oldwords[$j] ) { nogood = 1; break; }
  if( !nogood ) print;
}
