#!/bin/sh

PERL=/usr/local/bin/perl
SCRIPT=/usr/local/gramene/gramene-lib/scripts/pathway/load-pathway-search.pl
DIR=/scratch/kyc-tmp/pathways-40

#$PERL $SCRIPT --force -s arabidopsis -f $DIR/aracyc.tab
#$PERL $SCRIPT --force -s brachypodium -f $DIR/brachycyc.tab
#$PERL $SCRIPT --force -s coffea_canephora -f $DIR/coffeacyc.tab
$PERL $SCRIPT --force -s maize -f $DIR/maizecyc.tab
#$PERL $SCRIPT --force -s medicago_truncatula -f $DIR/mediccyc.tab
#$PERL $SCRIPT --force -s plant -f $DIR/plantcyc.tab
#$PERL $SCRIPT --force -s poplar -f $DIR/poplarcyc.tab
#$PERL $SCRIPT --force -s rice -f $DIR/ricecyc.tab
#$PERL $SCRIPT --force -s solanum_lycopersicum -f $DIR/lycocyc.tab
#$PERL $SCRIPT --force -s solanum_tuberosum -f $DIR/potatocyc.tab
#$PERL $SCRIPT --force -s sorghum_bicolor -f $DIR/sorghumcyc.tab
