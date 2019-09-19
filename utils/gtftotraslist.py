#!/usr/bin/env python3
import sys
import os
import pandas as pd


FN = sys.argv[1]

#CHROMS = ['2R','2L','3R','3L','X','Y_unplaced','UNKN'] # AgamP4 except Mt
CHROMS = ['1','2','3'] # AaegL5 just the chroms (note mito is MT)

print(FN, file=sys.stderr)

d = pd.read_csv(FN, sep='\t', comment='#', header=None,
            names=['seqid',
                   'source',
                   'type',
                   'start',
                   'end',
                   'score',
                   'strand',
                   'phase',
                   'attributes'],
                dtype={'seqid':str})

d = d.loc[d['type']=='transcript' ,:]
# filter out Mt
d = d.loc[d['seqid'].isin(CHROMS) ,:]
# extract transcript_id
t = d['attributes'].apply(
                    lambda x: dict([_.strip().split() for _ in
                    x.split(';') if _])['transcript_id'].strip('"'))
t = t.unique()
print(t.shape[0], 'unique transcript_ids', file=sys.stderr)
for x in t:
    print(x)
