### 准备工作（every node）

1. 执行 `sh ./prerequisite.sh` 进行相关内核参数修改，关闭防火墙及 swap 分区等
2. 设置主机名，并将所有节点主机名及对应IP写入每个服务器上的 /etc/hosts

### 安装 docker（every node）

执行 `sh install-docker.sh`，添加阿里云的docker repo，安装并配置docker

### 安装 kube 工具链（every node）

执行 `sh install-kubetools.sh`，添加阿里云的 kube repo，下载相关工具包括，kubeadm，kubelet，kubectl

### 预下载 k8s.gcr.io 相关镜像（every node）

由于不可描述的原因，我们无法直接从 k8s.gcr.io 下载镜像，因此只能利用docker本地镜像的功能预先下载所需镜像

1. 执行 `kubeadm config images list` 列出相应镜像
2. 修改 `gcr-pull.sh` 中对应镜像的版本号
3. 执行 `sh ./gcr-pull.sh` 从阿里云下载对应镜像

### 初始化主节点（only master）

1. 执行 `kubeadm config print init-defaults  > kubeadm-config.yaml` 生成默认配置
2. 修改 kubeadm-config.yaml
    - 改 advertiseAddress 值为主节点 IP
    - 修改 networking 配置，设置 pod 子网段 podSubnet
3. 执行 `kubeadm init --config kubeadm-config.yaml` 完成主节点初始化，初始化成功后会提示初始化node的命令，可以复制下来留用
4. 执行 `sh ./kubectl.sh` 进行 kubectl 工具配置
5. 执行 `kubectl cluster-info` 查看安装状态


### 安装 flannel 网络插件（only master）

执行 `kubectl apply -f ./kube-flannel.yaml` 进行 flannel 安装

### 初始化其他 node

在其他节点上执行 kubeadm join {master ip}:6443 --token xxx，其中 token 为主节点初始化后提示的 token

### 安装 dashboard（可选）

执行 `kubectl apply -f ./kube-dashboard`
    