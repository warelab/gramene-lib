DB=reactome_oryza_sativa40
DATA=/scratch/kyc-tmp/pathways-40/reactome.tab

mysqladmin drop -f $DB
mysqladmin create $DB
mysql $DB < reactome-search-schema.sql

# Assumes first line is header, fields declared in schema def order
mysqlimport -c 'search_term,pathway_id,object_id' --local --delete --ignore-lines=1 $DB $DATA
