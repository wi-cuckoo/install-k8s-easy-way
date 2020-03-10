#! /bin/sh

# close firewall
systemctl stop firewalld && systemctl disable firewalld
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config  && setenforce 0
iptables -F

# close swap
swapoff -a && sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# load kernel module
cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
