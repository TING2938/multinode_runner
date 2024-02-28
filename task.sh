#/usr/bin/env bash
#MRUNNER --NODES=10.10.10.1[1-3],10.10.10.15
#MRUNNER --CONTAINER=container_name

set -u

# set some environment variables here
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7

# Change for multinode config
DISTRIBUTED_ARGS=(
    --nproc_per_node 8
    --nnodes $NUM_NODES 
    --node_rank $NODE_RANK
    --master_addr $MASTER_ADDR 
    --master_port 8768
)
echo "distributed args: ${DISTRIBUTED_ARGS[@]}"

torchrun ${DISTRIBUTED_ARGS[@]} \
    path/to/train.py 