#!/bin/sh

PERL=/usr/local/bin/perl
SCRIPT=/home/kclark/gramene-lib/scripts/pathway/load-pathway-search.pl
DIR=/scratch/kyc-tmp/pathways

$PERL $SCRIPT --force -s arabidopsis -f $DIR/aracyc.tab
$PERL $SCRIPT --force -s brachypodium -f $DIR/brachycyc.tab
$PERL $SCRIPT --force -s solanum_lycopersicum -f $DIR/lycocyc.tab
$PERL $SCRIPT --force -s maize -f $DIR/maizecyc.tab
$PERL $SCRIPT --force -s poplar -f $DIR/poplarcyc.tab
$PERL $SCRIPT --force -s solanum_tuberosum -f $DIR/potatocyc.tab
$PERL $SCRIPT --force -s rice -f $DIR/ricecyc.tab
$PERL $SCRIPT --force -s sorghum_bicolor -f $DIR/sorghumcyc.tab
