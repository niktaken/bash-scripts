#!/bin/bash
counter=1010101150
#FILES=/media/sf_share/smoke/*.csv
FILES=./*.csv
for f in $FILES
do
  echo "Processing $f file..."

  payload=$(head -2 $f | tail -1)
  header=$(head -1 $f | tail -1)

#  echo $header
#  echo $payload
  for l in SOURCE_TRX_NUMBER POSCODE POS_CODE
  do
     echo $l
     indexArray=$(echo $header | sed "s/,/\n/g" | awk '{printf("%d %s\n", NR, $0)}'|  grep $l)
#    echo $indexArray
     index="$(cut -d' ' -f1 <<<"$indexArray")" 
     label="$(cut -d' ' -f2 <<<"$indexArray")"
     tag="%%"`echo $label | sed 's/.\(.*\)/\1/' | sed 's/\(.*\)./\1/'`"%%"
#    echo $index $label $tag $l
     if [ $tag != "%%%%" ]
     then
       payload=$(echo $payload| sed 's/[^,]*/'$tag'/'$index)
     else
       echo "TAG" $label "NOT FOUND"
     fi

  done
counter=$((counter+1))

##replacments


payload="${payload/'%%POSCODE%%'/'1980000218'}"
payload="${payload/'%%POS_CODE%%'/'1980000218'}"
payload="${payload/'%%SOURCE_TRX_NUMBER%%'/$counter}"
filename="${f/'.csv'/''}"


#echo $filename
echo $header > $filename"_header.csv"
echo $payload > $filename"_"$counter".csv_pld"

done

## cleanup

mkdir -p "headers"
mkdir -p "pld"

mv *_header.csv "headers"
mv *.csv_pld "pld"
cd pld
for ff in *.csv_pld; do mv "$ff" "${ff/'.csv_pld'/'.csv'}"; done;
