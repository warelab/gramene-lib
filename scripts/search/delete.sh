#
# Use with caution!
#

#curl 'http://brie.cshl.edu:8983/solr/grm-search/update?commit=true' -d '<delete><query>*:*</query></delete>'

curl 'http://brie.cshl.edu:8983/solr/grm-search/update?stream.body=<delete><query>module:reactome*</query></delete>&commit=true'

#curl 'http://brie.cshl.edu:8983/solr/genome_features/update?stream.body=<delete><query>*:*</query></delete>&commit=true'

#curl 'http://brie.cshl.edu:8983/solr/ontologies/update?stream.body=<delete><query>*:*</query></delete>&commit=true'
