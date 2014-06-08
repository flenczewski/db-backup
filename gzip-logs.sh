#!/bin/sh

TODAY=`date +%s`
DIR_NAME=`date +%G-%m`
DOBA=86400

ls $1 | while read file
do
    MOD_DATE=`stat --format=%Y $1/${file}`
    DIFF=$(((TODAY-MOD_DATE)/DOBA))
    if [ $DIFF -gt 0 ] ; then
        echo "File ${file} is older then 1 days - gzipping file"
        gzip $1/${file}
    fi
done

if [ -d ${1}/_archive/${DIR_NAME} ] ; then
    echo ""
else
    echo "Create new archive dir: ${1}/_archive/${DIR_NAME}"
    mkdir $1/_archive/${DIR_NAME}
fi
mv $1/*.gz $1/_archive/${DIR_NAME}
