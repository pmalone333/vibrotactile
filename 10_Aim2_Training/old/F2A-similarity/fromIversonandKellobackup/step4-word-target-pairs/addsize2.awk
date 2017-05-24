BEGIN {
  while( getline<"f2a-lec.siz" > 0 ) {
    excsize[$1] = $5; 
    vissize[$1] = $6;
    incsize[$1] = $7;
    totsize[$1] = $8;
  }
}
{
  printf( "%s\t%d\t%d\t%d\t%d\n", $0,
    (excsize[$1]+excsize[$2]+excsize[$3]+excsize[$4]),
    (vissize[$1]+vissize[$2]+vissize[$3]+vissize[$4]),
    (incsize[$1]+incsize[$2]+incsize[$3]+incsize[$4]),
    (totsize[$1]+totsize[$2]+totsize[$3]+totsize[$4]) );
}
