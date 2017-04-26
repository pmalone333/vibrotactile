function dprime = calcDprime(h,fa)

zH = norminv(mean(h)); % z scored hit rate
zFA = norminv(mean(fa)); % z scored false alarm rate 

dprime = zH - zFA;

end