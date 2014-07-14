#!/bin/bash

# 
# This script will download the OBO files needed to build the ontology db
# Author: Ken Youens-Clark
# 

DIR="/scratch/kyc-tmp/obo-files-42"

echo "Downloading OBO files to $DIR"

if [ ! -d $DIR ]; then
    mkdir -p $DIR
fi;

cd $DIR
rm -f *.obo

ncftpget -v ftp://ftp.geneontology.org/go/ontology/go.obo

wget -v -O so.obo http://sourceforge.net/p/song/svn/HEAD/tree/trunk/so-xp-simple.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/tags/live/plant_ontology.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/trunk/ontology/collaborators_ontology/gramene/traits/trait.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/trunk/ontology/collaborators_ontology/gramene/taxonomy/GR_tax-ontology.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/trunk/ontology/collaborators_ontology/gramene/temporal_gramene.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/trunk/ontology/collaborators_ontology/plant_environment/environment_ontology.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/trunk/ontology/OBO_format/po_anatomy.obo

wget -v http://palea.cgrb.oregonstate.edu/viewsvn/Poc/trunk/ontology/OBO_format/po_temporal.obo
