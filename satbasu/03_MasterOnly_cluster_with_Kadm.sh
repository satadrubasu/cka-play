#/bin/sh
# EXECUTE ON MASTER NODE ONLY 
# Install a single control-plane Kubernetes cluster
# Install a Pod network on the cluster so that your Pods can talk to each other


## kubeadm allows you to pass a KubeletConfiguration structure during kubeadm init. This KubeletConfiguration can include the cgroupDriver field which controls the cgroup driver of the kubelet.
cat <<EOF | sudo tee ~/kubeadm-config.yaml
kind: ClusterConfiguration
apiVersion: kubeadm.k8s.io/v1beta2
kubernetesVersion: v1.21.4
---
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd
EOF

# Such a configuration file can then be passed to the kubeadm command:
#   kubeadm init --config kubeadm-config.yaml 
#  Kubeadm uses the same KubeletConfiguration for all nodes in the cluster. 
# The KubeletConfiguration is stored in a ConfigMap object under the kube-system namespace.
# Executing the sub commands init, join and upgrade would result in kubeadm writing the KubeletConfiguration 
#  as a file under /var/lib/kubelet/config.yaml and passing it to the local node kubelet.

kubeadm init --config kubeadm-config.yaml
# --pod-network-cidr=192


# Your Kubernetes control-plane has initialized successfully!

# To start using your cluster, you need to run the following as a regular user:

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Alternatively, if you are the root user, you can run:
#   export KUBECONFIG=/etc/kubernetes/admin.conf

# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Then you can join any number of worker nodes by running the following on each as root:

# kubeadm join 10.0.2.15:6443 --token b7ngs5.buiqeoza5bbtyno5 \
# 	--discovery-token-ca-cert-hash sha256:ed410b6114a95c3eb5ebb36252ff2af3dc6a749780d9782f2c137ea7d895f89f