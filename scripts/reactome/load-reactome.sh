#
# Set this section...
#
DB=reactome_oryza_sativa40
HOST=cabot
DATA=/scratch/kyc-tmp/build40/pathways/reactome.tab

#
# Leave the rest alone...
#
mysqladmin -h $HOST drop -f $DB
mysqladmin -h $HOST create $DB
mysql -h $HOST $DB < reactome-search-schema.sql

#
# Assumes first line is header, fields declared in schema def order
#
mysqlimport -h $HOST -c 'search_term,pathway_id,object_id' --local --ignore-lines=1 $DB $DATA
