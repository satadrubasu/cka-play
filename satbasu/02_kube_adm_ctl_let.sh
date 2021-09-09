#/bin/sh

#Download the Google Cloud public signing key:
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

# Add the Kubernetes apt repository:
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo apt-get update

# Just to list all available versions of kubeadm - we will use 1.21 version to enable upgrade later to 1.22
apt list -a kubeadm 
#   kubeadm/kubernetes-xenial 1.22.1-00 amd64
#   kubeadm/kubernetes-xenial 1.22.0-00 amd64
#   kubeadm/kubernetes-xenial 1.21.4-00 amd64

sudo apt-get install -y kubelet=1.21.4-00 kubeadm=1.21.4-00 kubectl=1.21.4-00
sudo apt-mark hold kubelet kubeadm kubectl

## NOTE : The kubelet is now restarting every few seconds, as it waits in a crashloop for kubeadm to tell it what to do.
