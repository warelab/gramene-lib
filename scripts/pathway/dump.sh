#!/bin/sh

SCRIPT=/home/kclark/gramene-lib/scripts/pathway/format-pathway-data.pl
DATA_DIR=/scratch/kyc-tmp/pathways-38

cd $DATA_DIR

#echo "ara"
#$SCRIPT -d ./aracyc/10.0/data -o $DATA_DIR/aracyc.tab 1>ara.out 2>&1
#
#echo "brachy"
#$SCRIPT -d ./brachycyc/2.0.1.2/data -o $DATA_DIR/brachycyc.tab 1>brachy.out 2>&1
#
#echo "coffee"
#$SCRIPT -d ./coffeacyc/1.1.1.2/data/ -o $DATA_DIR/coffeacyc.tab 1>coffee.out 2>&1
#
#echo "lyco"
#$SCRIPT -d ./lycocyc/2.0.1.1.2/data -o $DATA_DIR/lycocyc.tab 1>lyco.out 2>&1

echo "maize"
$SCRIPT -d ./maizecyc/2.1/data -o $DATA_DIR/maizecyc.tab 1>maize.out 2>&1

#echo "medicago"
#$SCRIPT -d mediccyc/1.0.1.2/data/ -o $DATA_DIR/mediccyc.tab 1>mediccyc.out 2>&1
#
#echo "plant"
#$SCRIPT -d plantcyc/7.0.1.2/data/ -o $DATA_DIR/plantcyc.tab 1>plantcyc.out 2>&1
#
#echo "poplar"
#$SCRIPT -d ./poplarcyc/5.0.1.2/data -o $DATA_DIR/poplarcyc.tab 1>poplar.out 2>&1
#
#echo "potato"
#$SCRIPT -d ./potatocyc/1.0.1.2/data -o $DATA_DIR/potatocyc.tab 1>potato.out 2>&1
#
#echo "rice"
#$SCRIPT -d ./ricecyc/3.3.1.2/data -o $DATA_DIR/ricecyc.tab 1>rice.out 2>&1
#
#echo "sorghum"
#$SCRIPT -d ./sorghumcyc/1.1.1.2/data -o $DATA_DIR/sorghumcyc.tab 1>sorghum.out 2>&1

echo "Done"
