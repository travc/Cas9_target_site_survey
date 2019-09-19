#!/bin/bash

INFILE="$1"
OUTFILE="${INFILE%.gff3}.gene_table"

HEADERLINE="name	chrom	strand	txStart	txEnd	cdsStart	cdsEnd	exonCount	exonStarts	exonEnds	score	name2	cdsStartStat	cdsEndStat	exonFrames"

tmpfile=$(mktemp /tmp/gtftogenetable.XXXXXX)
gff3ToGenePred="`dirname $(readlink -f $0)`/gff3ToGenePred"

echo "$gff3ToGenePred $INFILE '->' $OUTFILE"

$gff3ToGenePred -allowMinimalGenes -processAllGeneChildren "$INFILE" "$tmpfile"
echo "$HEADERLINE" > "$OUTFILE"
cat "$tmpfile" >> "$OUTFILE"
rm "$tmpfile"


