layer=_health8-copy-
for i in {2..15}
do
    let "a = 17 - $i"
    let "b = $i+1"
    mv _00$a$layer$i.png stack_death$b.png 
done
