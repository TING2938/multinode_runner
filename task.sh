#/usr/bin/env bash
#MRUNNER --NODES=localhost
set -u

script_root_dir=$(realpath "$(dirname ${BASH_SOURCE[0]})")
echo "script_root_dir: ${script_root_dir}"

export CUDA_DEVICE_MAX_CONNECTIONS=1
export CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7
export OMP_NUM_THREADS=1
export NCCL_DEBUG=WARN

# Change for multinode config
DISTRIBUTED_ARGS=(
    --nproc_per_node 8
    --nnodes $NUM_NODES 
    --node_rank $NODE_RANK
    --master_addr $MASTER_ADDR 
    --master_port 8768
    --rdzv-id $TASK_ID
)
echo "distributed args: ${DISTRIBUTED_ARGS[@]}"

# torchrun ${DISTRIBUTED_ARGS[@]} \
#     ${script_root_dir}/train.py \
#         --model-path path/to/model \
#         2>&1 | tee -a output_rank${NODE_RANK}.log