#! /bin/sh

mkdir -p $HOME/.kube
cp -i --force /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -u) $HOME/.kube/config
