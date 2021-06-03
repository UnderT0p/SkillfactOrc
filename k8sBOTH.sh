#!/bin/bash
sudo apt-get update -y  && sudo apt-get install apt-transport-https -y
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo swapoff -a
sudo modprobe br_netfilter
sudo sysctl -p
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo apt-get install docker.io -y
sudo usermod -aG docker ansible
sudo systemctl restart docker
sudo systemctl enable docker.service
sudo apt-get install -y kubelet kubeadm kubectl
sudo systemctl daemon-reload
sudo systemctl start kubelet
sudo systemctl enable kubelet.service
sudo systemctl status docker