## `mrunner`: run deep learning tasks (torchrun, ...) on multiple nodes

When running deep learning tasks on multiple nodes (such as using the torchrun launcher), you need to execute the task script on each node and set different rank parameters for each node. When there are many nodes, this process will be very cumbersome, especially deep learning tasks that may be started and disconnected frequently. Therefore, this tool simplifies the process: execute the script once and it can run simultaneously on multiple nodes.

### 1. Usage

It's very simple to use `mrunner`, just execute 

```bash
./mrunner your_task_script.sh
```

mrunner will read some information from the script, including:
1. Node information: On which nodes the script needs to be run. Running tasks on multiple nodes is achieved through the `pdsh` tool. Therefore, you can specify which nodes need to run the task through the syntax of `pdsh`, and you should install `pdsh` tool (eg. `apt install pdsh`)
2. Container name on the node: mrunner assumes that the task is running in docker

A simple [torchrun script](./task.sh) is as follows:

```bash
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
```

in this script, you can use some variables:

  - NUM_NODES   : number of nodes
  - MASTER_ADDR : address of master node
  - NODE_RANK   : rank of each node
  - TASK_ID     : task id

for more details, you can run `./mrunner -h` for help
