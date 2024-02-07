## 多机运行脚本（torchrun, ...）

### 1. 安装依赖包

- pdsh

  `apt install pdsh`

- ssh

  将[config](config)文件修改后放到`~/.ssh/`路径下，并配置节点间免密连接

### 2. task脚本

task脚本开头需要写上用哪些节点进行运算

```
#MRUNNER --NODES=localhost
```

其中的节点名称需要与[config](config)文件中的Host名称对应，有效的写法包括：
- `#MRUNNER --NODES=worker[1-2]`
- `#MRUNNER --NODES=worker1,worker2`

以上两种写法均表示使用`worker1`和`worker2`两个节点

### 3. 启动`mrunner`

```bash
./mrunner.sh task.sh

# 也可以传递参数给task.sh脚本
# ./mrunner.sh task.sh 1 2
```

