# Project: Monitoring Kubernetes Applications Using Prometheus and Grafana on EC2 Instances (2 Hours)

## Project Overview

In this project, you will deploy a Kubernetes application on AWS EC2 instances and set up a monitoring stack using Prometheus and Grafana. The goal is to monitor the application's performance and visualize metrics using Grafana dashboards. This project is designed to test your knowledge of deploying and configuring monitoring solutions in a Kubernetes environment on AWS.

## Project Objectives
+ Deploy a Kubernetes cluster on EC2 instances.
+ Install Prometheus to monitor Kubernetes cluster metrics.
* Install Grafana and configure it to visualize metrics from Prometheus.
* Create custom Grafana dashboards to monitor specific application metrics.
* Demonstrate how to set up alerts in Grafana based on specific thresholds.
+ erminate all AWS resources after completing the project.

## Project Requirements
* AWS EC2 Instances: Launch a minimum of 3 t2.micro instances for the Kubernetes master and worker nodes.
+ Kubernetes Cluster: Set up a Kubernetes cluster using Kubeadm on the EC2 instances.
* Prometheus: Deploy Prometheus on the Kubernetes cluster to collect metrics.
+ Grafana: Deploy Grafana on the Kubernetes cluster and configure it to use Prometheus as a data source.
* ustom Dashboards: Create custom Grafana dashboards to monitor application metrics.
+ Alerting: Set up basic alerts in Grafana for key metrics (e.g., CPU usage, memory usage).
* Termination: Ensure all AWS resources are terminated after the project is complete.


### Step-by-Step Project Tasks
### 1. Launch AWS EC2 Instances (20 Minutes)
* Launch three EC2 instances of type t2.micro in the same VPC and availability zone.
+ Configure security groups to allow SSH access (port 22) and necessary ports for Kubernetes, * * * * *+ Prometheus, and Grafana (e.g., ports 9090, 3000).
+ SSH into the instances and update the package manager.

```sh
ssh -i <key-pair> ubuntu@<instance-ip>
```

### 2. Set Up a Kubernetes Cluster (30 Minutes)
* On the master node, install Kubeadm, Kubelet, and Kubectl.
+ Initialize the Kubernetes cluster using Kubeadm.
* Join the worker nodes to the master node to complete the cluster setup.
+ Verify that the cluster is working by deploying a sample application (e.g., Nginx).


```sh
kubectl get nodes
```
![alt text](<images/Screenshot from 2024-08-30 12-09-22.png>)

### 3. Deploy Prometheus on Kubernetes (20 Minutes)
+ Create a Kubernetes namespace for monitoring tools.
```sh
kubectl create namespace monitoring
```

* Use a Helm chart to deploy Prometheus or manually deploy Prometheus using Kubernetes manifests.

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```
+ Expose Prometheus using a Kubernetes service.

```sh
helm install prometheus prometheus-community/prometheus --namespace monitoring
```
* Verify that Prometheus is collecting metrics from the Kubernetes cluster.

![alt text](<images/Screenshot from 2024-08-30 12-15-16.png>)


### 4. Deploy Grafana on Kubernetes
* Deploy Grafana in the monitoring namespace.

```sh
helm repo add grafana https://grafana.github.io/helm-charts
```

```sh
helm install grafana grafana/grafana --namespace monitoring
```

![alt text](<images/Screenshot from 2024-08-30 12-19-55.png>)

![alt text](<images/Screenshot from 2024-08-30 12-20-46.png>)


+ Expose Grafana using a Kubernetes service and set up port forwarding or a LoadBalancer for external access.

```sh
kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

```sh
kubectl port-forward service/grafana --address 0.0.0.0 30001:80 --namespace monitoring
```

![alt text](<images/Screenshot from 2024-08-30 12-22-32.png>)