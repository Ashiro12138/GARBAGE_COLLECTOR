layer=_Stack_hit8-copy-
for i in {2..15}
do
    let "a = 17 - $i"
    let "b = $i+1"
    mv _000$a$layer$i.png stack_death$b.png 
done
