#!/usr/bin/env bash
## env to export
# MUN_NODES
# MASTER_ADDR
# NODE_RANK
# TASK_ID

set -u
job_script=$1
############################################
NODES=`cat ${job_script} | grep '#MRUNNER' | grep '\-\-NODES=' | awk -F '=' '{print $2}'`
RCMD="pdsh -R ssh -w ${NODES}"
MASTER_ADDR=`${RCMD} 'echo rank%n, $(hostname -I)' | grep rank0 | awk '{print $3}'`
NUM_NODES=`${RCMD} "echo rank%n" | wc -l`
WORKDIR=`pwd`
TASK_ID="mrunner-`cat /proc/sys/kernel/random/uuid`"

ENVs=(
    NUM_NODES=${NUM_NODES}
    MASTER_ADDR=${MASTER_ADDR} 
    NODE_RANK=%n
    TASK_ID=${TASK_ID}
)

function exit_task {
    cmd="pkill -f ${TASK_ID}"
    ${RCMD} "bash -c \" ${cmd} \" "
    echo Mrunner exit!
}
trap exit_task SIGINT SIGTERM ERR EXIT

cmd="cd ${WORKDIR}; ${ENVs[@]} bash ${@:1}"
${RCMD} "bash -c \" ${cmd} \" " 2>&1 | tee output_${TASK_ID}.log