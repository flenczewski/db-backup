#!/bin/bash

# mysql setup
MYSQL_USER='db-username'
MYSQL_PASS='db-password'

DATE=`date +%Y%m%d`
DIR="/backup"

mkdir $DIR/$DATE
mkdir $DIR/$DATE/mysql

for i in `echo "show databases" | mysql -u$MYSQL_USER -p$MYSQL_PASS | grep -v Database` 
    do 
    mysqldump  -u$MYSQL_USER -p$MYSQL_PASS --database $i > $DIR/$DATE/mysql/$i 
    gzip $DIR/$DATE/mysql/$i
done
tar -czvf $DIR/$DATE/mysql.tar.gz $DIR/$DATE/mysql
rm -rf $DIR/$DATE/mysql

# clean files old more than 7 days
TODAY=`date +%s`
DAY=86400

ls $DIR | while read file
do
    MOD_DATE=`stat --format=%Y $DIR/${file}`
    DIFF=$(((TODAY-MOD_DATE)/DAT))
    if [ $DIFF -gt 7 ] ; then
        echo "File ${file} is older then 7 days - removeing..."
        rm -rf $DIR/${file}
    fi
done
