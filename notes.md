# Install
conda create -n chopchop python=2.7 biopython numpy scipy pandas

# download chopchop
https://bitbucket.org/valenlab/chopchop

# download genome `.3bit` and bowtime index `.*.ebwt` datafiles for reference
http://chopchop.cbu.uib.no/bin/genomes/

# Setup
`mkdir datafiles`
`cd datafiles`
download the appropriate gff3 and gtf references
- Aedes-aegypti-LVP_AGWG_BASEFEATURES_AaegL5.1.gff3 
- Aedes-aegypti-LVP_AGWG_BASEFEATURES_AaegL5.1.gtf 
- Anopheles-gambiae-PEST_BASEFEATURES_AgamP4.12.gff3
- Anopheles-gambiae-PEST_BASEFEATURES_AgamP4.12.gtf

convert annotations gtf to a `gene_table` using
`utils/gff3togenetable.sh Aedes-aegypti-LVP_AGWG_BASEFEATURES_AaegL5.1.gff3`

extract transcript id list
edit script `genelist2translist.py` to set the chromosomes which should be used
`../utils/genelist2translist.py Aedes-aegypti-LVP_AGWG_BASEFEATURES_AaegL5.1.gtf > transcript_list_Aaegypti_L5.1`

# Modify chopchop to increase the `TARGET_MAX`
AgamP4.11 results in some targets just under 5Kbp, but chopchop has a max of 4kbp
AaegyptiL5.1 has a target just over 5Kpb... 
Just change the constant in chopchop.py (line 53):
`TARGET_MAX = 60000`

In parseBowtie function:
Add the `converters={2:str}` part to line 1220:
```
    sam = pandas.read_csv(bowtieResultsFile, sep='\t', names=list(range(14)),
                          header=None, index_col=False, converters={2:str})
```

# `all_transcripts_run/run.py`
set TRANSFN and GENOME variables

`run.py 2>&1 | tee run_Aaegypti_L5.1.log`

########


# Testrun
`./chopchop.py -G AgamP4 -o foo -Target AGAP003035-RA`

```
./chopchop.py \
--genome AgamP4 \
--mode 1 # Cas9 \
--target WHOLE
--guideSize 20  # default \
--maxMismatches 3  # default \
--maxOffTargets 300 # default \
--PAM NGG \ # default
#--scoreGC # code seems inconsistent on this, so default \
--scoringMethod XU_2015
--targets
```

`./chopchop.py -G AgamP4 -o foo -t WHOLE --scoringMethod XU_2015 --targets AGAP000553-RA > ../tests/AGAP000553-RA.out`

*can only do one target at a time*


```
CRISPR_DEFAULT = {"GUIDE_SIZE" : 20,
                  "PAM": "NGG",
                  "MAX_OFFTARGETS" : 300,
                  "MAX_MISMATCHES" : 3,
                  "SCORE_GC" : False, # this is already scored in many models!
                  "SCORE_FOLDING" : True}
```

# compare results
`./diff_tests.sh AGAP000553-RA | less -R`
(or use meld)


# Adding gene name and combining all chopchop output files
# Instead: stream awk output into python using popen (see notebook)
Sooo much faster than using python
```
cd AgamP4.11
time awk -F '\t' 'BEGIN{OFS=FS}{if(FNR==1){if(NR==FNR){print $0, "transcript_id"}}else{print $0, FILENAME}}' AGAP* > ../combined.out
```


