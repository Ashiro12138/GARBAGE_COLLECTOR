layer=_Layer 
for i in {1..53}
do
    let "a = 53 - $i"
    mv "_000$a$layer $i.jpg" menu_sprite$i.jpg
done
