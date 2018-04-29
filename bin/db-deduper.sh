#!/bin/bash

c=0
ins="insert into file_dedupe.files (filename,checksum,path) values"

cd "/media/jimconn/My Book/redapt/jimconn-redapt/jimconn"

find . -type f -exec sha1sum {} \; | \
while read sum file
do 
    file=$(echo $file | sed 's/^\.//')
    file="$(pwd)$file"
    path=$(dirname $file)
    
    this="(\"$file\",\"$sum\",\"$path\")"
    
    if [ $c = 0 ]
    then
        stmt="$this"
        let c++
    elif [ $c -lt 50 ]
    then
        stmt="$stmt, $this"
        let c++
    else
        stmt="$stmt, $this"

        echo 'inserting '$stmt
        echo $ins $stmt | mysql -u jimconn -pblah file_dedupe
        echo
        c=0
    fi
done
