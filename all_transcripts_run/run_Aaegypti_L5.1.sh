#!/bin/bash

TRANSFN='../datafiles/transcript_list_Aaegypti_L5.1'
GENOME='Aaegypti_L5'

# >>> conda init >>>
__conda_setup="$(CONDA_REPORT_ERRORS=false ~/miniconda3/bin/conda shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "~/miniconda3/etc/profile.d/conda.sh" ]; then
        . "~/miniconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="~/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

pushd ../dist/
conda activate chopchop

#stdbuff -o0 echo "{#} {}"; \

/usr/bin/time nice -n 9 parallel --joblog run_job.log -a "$TRANSFN" '\
ulimit -Sn 65535; \
./chopchop.py -G '$GENOME' \
 -t WHOLE --scoringMethod XU_2015 \
 -o "tmp_{}_out" \
 --targets {} > "../all_transcripts_run/{}" ;\
rm -rf "tmp_{}_out"
'

conda deactivate
popd

