#!/bin/bash

#Vars Aliases that you will need to change, check below if you need help espscially about single quotes in the aliases
PAGE=""
LASTIMG=""
alias IMGCODE=''
alias IMGTYPECODE=''
alias NEXTPAGECODE=''

#Vars you should not need to change
NUMBER=1

<<VARS/ALIASES
VAR PAGE
Change to the first page of the comic

VAR LASTIMG
Change to the last image file of the comic

ALIAS notes
If you need to use a single quote then it will have to look like '"'"'
https://stackoverflow.com/questions/1250079/how-to-escape-single-quotes-within-single-quoted-strings

When using cut with a delimiter of " you can to escape it with \ not encase it in '

To get your aliases I suggest you use curl and then pipe to things till you get the correct answer, test it on a few pages and if all good then test the script.
The developer console in firefox can help you find what your looking for
e.g.
$ curl -s https://xkcd.com/1/
$ curl -s https://xkcd.com/1/ |grep -A1 'div id="comic"'
$ curl -s https://xkcd.com/1/ |grep -A1 'div id="comic"' |tail -n1
$ curl -s https://xkcd.com/1/ |grep -A1 'div id="comic"' |tail -n1 |cut -d\" -f2
$ curl -s https://xkcd.com/1/ |grep -A1 'div id="comic"' |tail -n1 |cut -d\" -f2 |sed 's;//;https://;'
That gives us the IMGCODE alias and after coverting the single quotes we get the below
$ alias IMGCODE='grep -A1 '"'"'div id="comic"'"'"' |tail -n1 |cut -d\" -f2 |sed '"'"'s;//;https://;'"'"''
Test it by running 
$ curl -s https://xkcd.com/1/ |IMGCODE


ALIAS IMGCODE
Code that seperates the image URL from the page content
grep, cut, tail, head, sed are your friends here
e.g. alias IMGCODE='grep -A1 "'"'"'div id="comic""'"'"' |tail -n1 |cut -d\" -f8'

ALIAS IMGTYPECODE
Code that gets the image file extension from the image variable
Usually a simple cut like below will work
 cut -d. -f3

ALIAS NEXTPAGECODE
Code that gets the next page URL from the page content
Use same tools as IMGCODE

VAR NUMBER
Starting number for the output image files, useful when you need to run from a later page than number 1
VARS/ALIASES


#Allow the use of Aliases
shopt -s expand_aliases


#Returns page content or if page 404's gives data then exits
#$1 = page to check
#$2 = old page for exit data
function GetPageOrDie {
  PAGEDATA=`curl -sf $1`
  if  [ $? -ne 0 ];then
    printf "\nLast Good page was\n$2\nFailed on testing page\n$1\n"
    exit 1
  fi
}


while [[ $IMAGE != $LASTIMG  ]];do
  GetPageOrDie $PAGE $OLDPAGE
  IMAGE=`echo "$PAGEDATA" |IMGCODE`
  IMGTYPE=`echo "$IMAGE" |IMGTYPECODE`
  OLDPAGE=$PAGE
  PAGE=`echo "$PAGEDATA" |NEXTPAGECODE`
  wget -O images/$NUMBER.$IMGTYPE $IMAGE
  if [ $? -ne 0 ];then
    printf "\nProblem downloading image on line below\n$IMAGE\nLoop has exited before it was supposed to final page was\n$OLDPAGE\nThis sometimes happens on the last page due to different formatting\nDue to the unexpected break makepage.sh will not be run\n"
    break 0 &>/dev/null
  fi
  NUMBER=$((NUMBER+1))
done

if [ $? -eq 0 ];then
  ./makepage.sh
fi
