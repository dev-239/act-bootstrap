#!/bin/sh

LOGDIR="log"
LOGLEVEL=info
USERID=$1
ACT_BASEURL=$2

FACT_TYPES=types/fact-types.json
META_FACT_TYPES=types/metafact-types.json
OBJECT_TYPES=types/object-types.json
LOG=${LOGDIR}/bootstrap.log.`date +%s`

if [[ ! -d ${LOGDIR} ]]; then mkdir ${LOGDIR}; fi

if [ "$ACT_BASEURL" = "" ]; then
    echo "syntax: bootstrap.sh <user id> <act baseurl>"
    echo "example: bootstrap.sh 1 http://localhost:8080"
    exit 1
fi

export PYTHONPATH=$PYTHONPATH:`pwd`/bootstrap

ARGS="--userid $USERID --act-baseurl $ACT_BASEURL --loglevel $LOGLEVEL --logfile $LOG"

echo "Logging to $LOG"

bootstrap/act-bootstrap.py $ARGS --object-types ${OBJECT_TYPES} --fact-types ${FACT_TYPES} --meta-fact-types ${META_FACT_TYPES}
bootstrap/misp-threat-actors.py $ARGS
bootstrap/fireeye-carbanak.py $ARGS
