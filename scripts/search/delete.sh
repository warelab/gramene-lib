# curl 'http://brie.cshl.edu:8983/solr/grm-search/update?commit=true' -d '<delete><query>*:*</query></delete>'

curl 'http://brie.cshl.edu:8983/solr/grm-search/update?stream.body=<delete><query>module:ensembl_oryza_sativa_japonica</query></delete>&commit=true'