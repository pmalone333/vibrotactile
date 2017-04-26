awk -f fold-lex.awk f2a-inc.lex | sort +3 -4 | awk -f lec-numb.awk -v lec=0 | sort > f2a-inc.lec
awk -f fold-lex.awk f2a-vis.lex | sort +3 -4 | awk -f lec-numb.awk -v lec=399 | sort > f2a-vis.lec
awk -f fold-lex.awk f2a-exc2.lex | sort +3 -4 | awk -f lec-numb.awk -v lec=799 | sort > f2a-exc2.lec
join f2a-inc.lec f2a-vis.lec > t1
join t1 f2a-exc2.lec > f2a-lec2.txt
