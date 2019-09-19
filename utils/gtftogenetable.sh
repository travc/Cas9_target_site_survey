#!/bin/bash

INFILE="$1"
OUTFILE="${INFILE%.gtf}.gene_table"

HEADERLINE="name	chrom	strand	txStart	txEnd	cdsStart	cdsEnd	exonCount	exonStarts	exonEnds	score	name2	cdsStartStat	cdsEndStat	exonFrames"

tmpfile=$(mktemp /tmp/gtftogenetable.XXXXXX)
gtfToGenePred="`dirname $(readlink -f $0)`/gtfToGenePred"

echo "$gtfToGenePred $INFILE '->' $OUTFILE"

$gtfToGenePred -genePredExt -geneNameAsName2 "$INFILE" "$tmpfile"
echo "$HEADERLINE" > "$OUTFILE"
cat "$tmpfile" >> "$OUTFILE"
rm "$tmpfile"


