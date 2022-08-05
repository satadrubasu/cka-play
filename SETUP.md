Have Vagrant and Oracle Virtual BOX Installed.

brew install virtualbox --cask
brew install vagrant --cask
brew install vagrant-manager --cask


# Reference :
  https://www.youtube.com/watch?v=z3eXQbAuN4E&list=PL2We04F3Y_41jYdadX55fdJplDvgNGENo&index=3
  ( hard way ) + ( Prereq vagrant / virtual box )

# Vagrant to automate bringing up a k8s cluster

 3 VMS - 1 master + 2 worker , networks them to have access to internet and
  and installs docker as conntainer.Refer to the Vagrant File.  
 > vagrant up  
 > vagrant status
 > vagrant ssh master  


Before we use the ansible playbooks , fetch connection details.Display key file,host and port for ssh   
 > vagrant ssh-config  

configure these onto :
 ansible-plays/host_vars/master 
 ansible-plays/host_vars/node01
 ansible-plays/host_vars/node02
master = 127.0.0.1 -p 2222
node01 = 127.0.0.1 -p 2200
node02 = 127.0.0.1 -p 2201

Run the Ansible playbooks :
 > cd ./ansible-plays/kube-cluster
 > ansible-playbook site.yml



Step1] Install container on each node manually
Step2] Install kubeadm on all tools
Step3] Initialize the master server
Step4] Ensure Network Pre-requisites are met.
       - POD Network
Step5] Join Worker Node to Master Node.

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/


Step1a] Download the containerd-<VERSION>-<OS>-<ARCH>.tar.gz archive from https://github.com/containerd/containerd/releases , verify its sha256sum, and extract it under /usr/local
  > tar Cxzvf /usr/local containerd-1.6.2-linux-amd64.tar.gz 


Step1b] Manager the containerd with systemd
  Pre-requisite - Some version matching needed :
```
  ubuntu OS Version glibc version :
  ubuntu Jammy (22.04) = glibc (2.35-0ubuntu3.1)
  apt-cache madison libc6 = 2.35-0ubuntu3
  containerd 1.6.7 = runc v1.1.3
```
  download the containerd.service unit file from https://github.com/containerd/containerd/blob/main/containerd.service
  
 Put Location ( of unit file ) as root:
  ** Choosing this path : didnt complaint of only having [ ExecStartPre , ExecStart]
  /lib/systemd/system - standard systemd unit files

  wget https://raw.githubusercontent.com/containerd/containerd/main/containerd.service
  vi /lib/systemd/system/containerd.service ( Put contents from above )

  > systemctl daemon-reload  
  > systemctl enable --now containerd  
  > systemctl status containerd

** FAQ : the service.unit file fails - look for the correct lib6
```
sudo apt-get update -y
apt-cache madison libc6
sudo apt-get install -y libc6

```

Step 1c] Install runc 
 Download the runc.<ARCH> binary from https://github.com/opencontainers/runc/releases , verify its sha256sum,   
  and install it as /usr/local/sbin/runc  

 > wget https://github.com/opencontainers/runc/releases/download/v1.1.3/runc.amd64
 > install -m 755 runc.amd64 /usr/local/sbin/runc

Step 1d] Install CNI plugins:
  Download the cni-plugins-<OS>-<ARCH>-<VERSION>.tgz archive from https://github.com/containernetworking/plugins/releases , verify its sha256sum, and extract it under /opt/cni/bin  
 > wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
 > mkdir -p /opt/cni/bin
 > tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
 