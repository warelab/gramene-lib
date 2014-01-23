DB=reactome_oryza_sativa40
DATA=/scratch/kyc-tmp/build40/pathways/reactome.tab

mysqladmin -h cabot drop -f $DB
mysqladmin -h cabot create $DB
mysql -h cabot $DB < reactome-search-schema.sql

# Assumes first line is header, fields declared in schema def order
mysqlimport -h cabot -c 'search_term,pathway_id,object_id' --local --ignore-lines=1 $DB $DATA
