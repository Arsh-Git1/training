# TASK 1


### 1. Log in to Control Node

### 2. Install Packages
On All Nodes (Control Plane and Workers)

* Log in to the control plane node.

Create the Configuration File for containerd:

```sh
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

![alt text](<images/Screenshot from 2024-08-28 16-50-03.png>)

Load the Modules:

```sh
sudo modprobe overlay
sudo modprobe br_netfilter
```
![alt text](<images/Screenshot from 2024-08-28 16-50-10.png>)

Set the System Configurations for Kubernetes Networking:

```sh
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
![alt text](<images/Screenshot from 2024-08-28 16-50-18.png>)



Apply the New Settings:

```sh
sudo sysctl --system
```
![alt text](<images/Screenshot from 2024-08-28 16-50-29.png>)


Install containerd:

```sh
sudo apt-get update && sudo apt-get install -y containerd.io
```
![alt text](<images/Screenshot from 2024-08-28 16-51-11.png>)


Create the Default Configuration File for containerd:

```sh
sudo mkdir -p /etc/containerd
```

![alt text](<images/Screenshot from 2024-08-28 16-51-43.png>)


Generate the Default containerd Configuration and Save It:

sudo containerd config default | sudo tee /etc/containerd/config.toml

Restart containerd:

```sh
sudo systemctl restart containerd
```


Verify that containerd is Running:

```sh
sudo systemctl status containerd
```

![alt text](<images/Screenshot from 2024-08-28 16-54-05.png>)

![alt text](<images/Screenshot from 2024-08-28 16-52-58.png>)


Disable Swap:

```sh
sudo swapoff -a
```
Install Dependency Packages:

```sh
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
```

![alt text](<images/Screenshot from 2024-08-28 16-54-05.png>)

Download and Add the GPG Key:


```sh
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.27/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
```
![alt text](<images/Screenshot from 2024-08-28 16-54-52.png>)


Add Kubernetes to the Repository List:

```sh
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.27/deb/ /
EOF
```

![alt text](<images/Screenshot from 2024-08-28 16-56-48.png>)


Update the Package Listings:

```sh
sudo apt-get update
```

![alt text](<images/Screenshot from 2024-08-28 16-57-07.png>)

Install Kubernetes Packages:

```sh
sudo apt-get install -y kubelet kubeadm kubectl
```
![alt text](<images/Screenshot from 2024-08-28 16-57-40.png>)

Note: If you encounter a dpkg lock message, wait a minute or two and try again.
Turn Off Automatic Updates:

```sh
sudo apt-mark hold kubelet kubeadm kubectl
```
![alt text](<images/Screenshot from 2024-08-28 16-58-01.png>)

Log in to Both Worker Nodes and Repeat the Above Steps.

3. Initialize the Cluster
On the Control Plane Node, Initialize the Kubernetes Cluster:

```sh
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.27.11
```
![alt text](<images/Screenshot from 2024-08-28 17-01-22.png>)

Set kubectl Access:

```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
![alt text](<images/Screenshot from 2024-08-28 17-02-16.png>)



Test Access to the Cluster:

```sh
kubectl get nodes
```
![alt text](<images/Screenshot from 2024-08-28 17-02-35.png>)

4. Install the Calico Network Add-On
On the Control Plane Node, Install Calico Networking:

```sh
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
```
![alt text](<images/Screenshot from 2024-08-28 17-02-59.png>)

Check the Status of the Control Plane Node:

kubectl get nodes

![alt text](<images/Screenshot from 2024-08-28 17-03-23.png>)

5. Join the Worker Nodes to the Cluster
On the Control Plane Node, Create the Token and Copy the Join Command:

kubeadm token create --print-join-command
Note: Copy the full output starting with kubeadm join.
On Each Worker Node, Paste the Full Join Command:

sudo kubeadm join…
![alt text](<images/Screenshot from 2024-08-28 17-40-36.png>)

On the Control Plane Node, View the Cluster Status:

kubectl get nodes

Note: You may need to wait a few moments for all nodes to become ready.

![alt text](<images/Screenshot from 2024-08-30 11-42-46.png>)

![alt text](<images/Screenshot from 2024-08-30 11-43-14.png>)