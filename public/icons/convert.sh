#!/bin/bash
for f in *.svg
do
inkscape ${f} -w 24 -h 24 -e ${f:0:-4}24.png
inkscape ${f} -w 48 -h 48 -e ${f:0:-4}48.png 
inkscape ${f} -w 72 -h 72 -e ${f:0:-4}72.png
done
