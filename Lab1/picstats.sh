#!/bin/bash
#My lab 1.7
#this command show the total numbers of the regular files in the Directory ~/Pictures

totalf=`find ~/Pictures/ -maxdepth 1 -type f | awk '/\//{print ++c, $0}' | tail -n 1 | awk '{print $1}'
echo "The total files on ~/Pictures directory is of $total files."

#This command will show how much space on disk these files used
totals=`find ~/Pictures/ -type f -print0 |du --files0-from=- -shc | tail -n1 | awk '{print $1}'
echo "The total usage of disk space is $totals"

#This command will show the three largest files on ~/Pictures/
files=`find ~/Pictures/ -type f -print0 | du --files0-from=- -sh | sort -h |tail -3`
echo "three biggest files are
$files"
