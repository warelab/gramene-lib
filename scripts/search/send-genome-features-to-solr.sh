if [ "$#" -eq 0 ];then
    echo " Usage: $0 [files to process]"
    exit 1;
fi

URL="'http://brie.cshl.edu:8983/solr/genome_features/update?commit=true&f.taxonomy.split=true&f.ontology.split=true'";

while (($#)); do
    echo "curl $URL -H 'Content-type:application/csv' --data-binary @$1"
    shift;
done;
