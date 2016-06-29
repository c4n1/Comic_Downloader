#!/bin/bash

#for i in `seq 1 300`;do
#  touch testout/$i.jpg
#done 


function addimg {
  echo '<br>
        <img src="../images/'$1'">
	<br>
       ' >> pages/$2.html
}



PAGE=1
PAGECOUNT=0
echo '<center><body bgcolor="grey">' >> pages/$PAGE.html

for image in `ls images |sort -g`;do
  addimg $image $PAGE
  PAGECOUNT=$((PAGECOUNT+1))
  if [ "$PAGECOUNT" == 25 ];then
    PAGECOUNT=0
    OLDPAGE=$PAGE
    PAGE=$((PAGE+1))
    echo '<font size="20"><br><br><a href="'$PAGE'.html">NEXT<a>' >> pages/$OLDPAGE.html
    echo '<center><body bgcolor="grey">' >> pages/$PAGE.html
  fi
done
 

for PAGE in `ls pages |sort -g`;do
  echo '<br><br><a href="pages/'$PAGE'">'$PAGE'<a>' >> index.html
done
  




 
  
