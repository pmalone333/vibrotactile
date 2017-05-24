awk -f fold-lex.awk f2a-exc.lex | sort +3 -4 | awk -f lec-numb.awk -v lec=0 | sort > f2a-exc.lec
awk -f fold-lex.awk f2a-vis.lex | sort +3 -4 | awk -f lec-numb.awk -v lec=399 | sort > f2a-vis.lec
awk -f fold-lex.awk f2a-inc.lex | sort +3 -4 | awk -f lec-numb.awk -v lec=799 | sort > f2a-inc.lec
join f2a-exc.lec f2a-vis.lec > t1
join t1 f2a-inc.lec > f2a-lec.txt
