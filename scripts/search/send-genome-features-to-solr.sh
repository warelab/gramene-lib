if [ "$#" -eq 0 ];then
    echo " Usage: $0 [files to process]"
    exit 1;
fi

CURL=/usr/bin/curl
URL="'http://brie.cshl.edu:8983/solr/grm-search/update?commit=true&f.taxonomy.split=true&f.ontology.split=true'";

while (($#)); do
    echo $CURL $URL -H 'Content-type:application/csv' --data-binary @$1
    shift;
done;
