#
# This will drop and recreate the Gramene "ontology" database and load 
# with default data.
#

DB=ontology37
USER=kclark
PASS=g0p3rl!
HOST=cabot
ONT_BASE=$GRM_HOME/schemas/ontology/
SQL=$ONT_BASE/ontology.sql

echo "Recreating $DB on $HOST"

echo "DROP DATABASE IF EXISTS $DB" | mysql -h $HOST -u $USER -p$PASS

echo "CREATE DATABASE $DB" | mysql -h $HOST -u $USER -p$PASS

cat $SQL | mysql -h $HOST -u$USER -p$PASS $DB

echo "Importing default data"
mysqlimport --ignore-lines=1 -h $HOST -u$USER -p$PASS $DB --local $ONT_BASE/*.txt

echo "Done."

exit 0
