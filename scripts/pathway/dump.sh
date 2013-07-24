#!/bin/sh

SCRIPT=/home/kclark/gramene-lib/scripts/pathway/format-pathway-data.pl
OUT_DIR=/scratch/kyc-tmp/pathways

echo "ara"
$SCRIPT -d ./aracyc/10.0/data -o $OUT_DIR/aracyc.tab 1>ara.out 2>&1

echo "potato"
$SCRIPT -d ./potatocyc/1.0.1.2/data -o $OUT_DIR/potatocyc.tab 1>potato.out 2>&1

echo "lyco"
$SCRIPT -d ./lycocyc/2.0.1.1.2/data -o $OUT_DIR/lycocyc.tab 1>lyco.out 2>&1

echo "poplar"
$SCRIPT -d ./poplarcyc/5.0.1.2/data -o $OUT_DIR/poplarcyc.tab 1>poplar.out 2>&1

echo "rice"
$SCRIPT -d ./ricecyc/3.3.1.2/data -o $OUT_DIR/ricecyc.tab 1>rice.out 2>&1

echo "brachy"
$SCRIPT -d ./brachycyc/2.0.1.2/data -o $OUT_DIR/brachycyc.tab 1>brachy.out 2>&1

echo "sorghum"
$SCRIPT -d ./sorghumcyc/1.1.1.2/data -o $OUT_DIR/sorghumcyc.tab 1>sorghum.out 2>&1

echo "maize"
$SCRIPT -d ./maizecyc/2.0.2.2/data -o $OUT_DIR/maizecyc.tab 1>maize.out 2>&1

echo "Done"
