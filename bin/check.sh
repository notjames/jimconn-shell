#!/bin/bash

oct=10.17

for n in 83.253 83.173 83.120 82.200 83.158 82.171 83.18 83.161 83.132 82.100 83.108 82.224
do 
    echo $oct.$n
    echo '{}{"appl.name":""}' | nc -w 3 $oct.$n 9200
    echo
done
