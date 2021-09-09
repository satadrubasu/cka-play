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

sudo kubeadm init --apiserver-advertise-address=192.168.56.2
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

# kubeadm join 192.168.56.2:6443 --token wqpwwn.ezbmrhia808lcelt \
	--discovery-token-ca-cert-hash sha256:0df5cc202c2860f00601b2ef7b95f8fb8f81a57ba51d84a8bee1985701244ba6