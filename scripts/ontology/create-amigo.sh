#!/bin/bash

# 
# This script will parse and load the OBO files into an Amigo 1 db.
# Author: Ken Youens-Clark
#

VERSION="42"
DIR="/scratch/kyc-tmp/obo-files-42"
AMIGO_DB="amigo${VERSION}"
LOG="${0}.log"
DBHOST=cabot
USERNAME='kclark'
PASSWORD='g0p3rl!'
MYSQL="/usr/local/mysql/bin/mysql --host=$DBHOST --user=$USERNAME --password='$PASSWORD'"
PERL=/usr/local/bin/perl
BASE=/usr/local/ontologies
GOBASE=$BASE/geneontology/go-dev/trunk
GODBPERL=$GOBASE/go-db-perl

echo "Preparing $AMIGO_DB"
echo "drop database if exists $AMIGO_DB" | $MYSQL
echo "create database $AMIGO_DB" | $MYSQL
GO_SQL="$BASE/go-full.sql"

$PERL $GOBASE/sql/compiledb -t mysql -o $GO_SQL $GOBASE/sql/go-tables-FULL.sql

echo ''

$MYSQL $AMIGO_DB < $GO_SQL

cat /dev/null > $LOG

for FILE in `ls $DIR/*.obo`
do
    echo "Processing $FILE"

    $PERL -I$GODBPERL $GODBPERL/scripts/load-go-into-db.pl -datatype obo -h $DBHOST -u $USERNAME -p $PASSWORD -d $AMIGO_DB -append $FILE 1>>$LOG 2>>$LOG
done

echo "All done, check log file '$LOG'"
