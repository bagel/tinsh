#!/bin/sh
# Sum of text files lines in directory

if [ $# -lt 1 ] ; then
    echo "usage: $0 dir1 dir2 dir3 ..."
    exit 1
fi

count(){
    for files in $(ls) ; do
        if [ -d $files ] ; then
            let dirs_num=dirs_num+1
            cd $files
            count
        elif [ -f $files -a -r $files ] ; then
            let file_num=file_num+1
            #if [ "X$1" == "X-t" ] ; then
            #    #ftype=$(file -i $files | awk '$2 ~ /^text\/.*/{print "text"}')
            #    ftype=$(file -ib $files | cut -f 1 -d '/')
            #    if [ ! "X$ftype" == "Xtext" ] ; then
            #        continue
            #    fi
            #fi
            f=$(wc -l $files | cut -f 1 -d ' ')
            let line_num=line_num+f
        else
            continue
        fi
    done
    cd ..
}

#echo "name  line  file  dir"
for arg in $@ ; do
    line_num=0
    if [ -d $arg ] ; then
        file_num=0
        dirs_num=0
        cd $arg
        #count $1
        count
    elif [ -f $arg -a -r $arg ] ; then
        line_num=$(wc -l $arg | cut -f 1 -d ' ')
        file_num=
        dirs_num=
    else
        continue
    fi
    echo -e "${arg}: ${line_num}  ${file_num}  ${dirs_num}"
done
