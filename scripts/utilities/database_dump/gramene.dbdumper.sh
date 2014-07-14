#!/bin/bash
if [ -z "$GRMVER" ]
    then
        echo "Please set GRMVER environment variable to current release";
        exit;
fi

if [ -z "$1" ]
    then
        echo "Please list databases to export/copy.";
        exit;
fi

if [ -z "$DUMPDIR" ]
    then
        echo "No DUMPDIR provided. Defaulting to /mysql_internal";
        export DUMPDIR='/mysql_internal';
fi

echo "This will create text and mysqldumps of the given databases, and copy them into\
    place on brie4.";
echo "Dumping databases: $@";
echo "GRAMENE VERSION : $GRMVER";
echo "mkdir $DUMPDIR/gramene-$GRMVER (provide sudo password, if necessary)";
if [ ! -d "$DUMPDIR/gramene-$GRMVER" ]
    then
        sudo mkdir "$DUMPDIR/gramene-$GRMVER";
        sudo chmod 777 "$DUMPDIR/gramene-$GRMVER";
fi
cd "$DUMPDIR/gramene-$GRMVER";
echo "Creating directories $@";
mkdir $@
echo "chmod 777 on $@";
chmod 777 $@
echo "mysqldump -T"
find * -type d -exec sh -c 'mysqldump $1 -T $DUMPDIR/gramene-$GRMVER/$1' -- {} \; &
echo "mysqldump";
find * -type d -exec sh -c 'mysqldump $1 | gzip > $1.mysqldump.gz' -- {} \;
echo "create directories on brie4 (provide brie4 password, if necessary)";
ssh brie4 "mkdir -p /var/ftp/pub/gramene/release$GRMVER/data/database_dump/mysql-dumps/;\
    mkdir -p /var/ftp/pub/gramene/release$GRMVER/data/database_dump/text-dumps/"
echo "scp *.gz files"
scp *.gz brie4:/var/ftp/pub/gramene/release$GRMVER/data/database_dump/mysql-dumps/. &
echo "create master sql file"
find * -type d -exec sh -c 'cat $1/*.sql > $1.sql' -- {} \;
wait
echo "tar text dumps"
find * -type d | xargs -t -I DATABASE tar cfz DATABASE.tgz DATABASE
echo "scp *.tgz, *.sql files"
scp *.{tgz,sql} brie4:/var/ftp/pub/gramene/release$GRMVER/data/database_dump/text-dumps/.
echo "remove dirs, dumps, sql, etc $@ (LEAVING $DUMPDIR/gramene-$GRMVER IN PLACE)"
wait
rm -r *
echo "Success!"

