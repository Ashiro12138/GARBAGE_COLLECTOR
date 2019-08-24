layer=_Layer 
for i in {1..50}
do
    let "a = 51 - $i"
    mv "_00$a$layer $i.jpg" menu_sprite$i.jpg
done
