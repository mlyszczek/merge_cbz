#!/bin/bash 

# Copyright (c) 2016, Michał Łyszczek <michal.lyszczek@gmail.com>
# License: BSD-3-Clause, see license file

tmp=/tmp/merge_cbz/tmp
dst=/tmp/merge_cbz/dst
wd=`pwd`
num_of_files=`ls -1 | wc -l`
let curr_file=1
let c=0

progressbar()
{
        let "percent=(${curr_file}*100)/(${num_of_files})"
        prefix=`printf "%${#num_of_files}s/%${#num_of_files}s [" $curr_file $num_of_files`
        sufix=`printf "] %3g%%" ${percent}`
        let "left=`tput cols` - ${#prefix} - ${#sufix}"
        let "fill=(left * percent) / 100 - 1"
        if [[ $fill == -1 ]]
        then
                let fill=0
        fi
        let "empty=left - fill - 1"
        fills=`printf "%-${fill}s" ""`
        emptys=`printf "%-${empty}s" ""`
        echo -ne "\r"
        echo -ne "${prefix}${fills// /=}>${emptys// / }${sufix}"
}

rename_files()
{
        cd $tmp
        for f in `ls -1 $tmp | sort -V`
        do
                name=`printf "%05d" $c`
                mv "$f" "${dst}/${name}.${f##*.}"
                ((c++))
        done
}

[ -d $tmp ] || mkdir -p $tmp
[ -d $dst ] || mkdir -p $dst
rm -f $tmp/*
rm -f $dst/*

echo "Processing cbz files"
for f in `ls -1 *.cbz | sort -V`
do
        cd $wd
        unzip $f -d $tmp &> /dev/null
        rename_files
        ((curr_file++))
        progressbar
done

echo "Creating new cbz file"

cd $dst

if type pv &> /dev/null 
then
        pv * | zip > $tmp/merged.cbz
else
        zip merged.cbz * &> /dev/null
fi

mv $tmp/merged.cbz $wd
rm -f $tmp/*
rm -f $dst/*
exit 0
