# Day-9 Task

## Stage 1: Setting Up the Kubernetes Cluster and Static Web App

### 1. Set Up Minikube:
 - Ensure Minikube is installed and running on the local Ubuntu machine.
 - Verify the Kubernetes cluster is functioning correctly.

 ![alt text](<img/Screenshot from 2024-07-18 16-30-11.png>)

### 2. Deploy Static Web App:
 - Create a Dockerfile for a simple static web application (e.g., an HTML page served by Nginx).
 - Build a Docker image for the static web application.
 
 ![alt text](<img/Screenshot from 2024-07-18 16-30-11.png>)
 
 - Push the Docker image to Docker Hub or a local registry.
 
 ![alt text](<img/Screenshot from 2024-07-18 17-06-10.png>)

### 3. Kubernetes Deployment:
 - Write a Kubernetes deployment manifest to deploy the static web application.
 - Write a Kubernetes service manifest to expose the static web application within the cluster.
 - Apply the deployment and service manifests to the Kubernetes cluster.

### Deliverables:

 - Dockerfile for the static web app
 - Docker image URL

    https://hub.docker.com/repository/docker/harshpatil02/custom-nginx-image/general

 - Kubernetes deployment and service YAML files

![alt text](<img/Screenshot from 2024-07-19 15-36-41.png>)
![alt text](<img/Screenshot from 2024-07-19 15-37-46.png>)

---
## Stage 2: Configuring Ingress Networking

### 4. Install and Configure Ingress Controller:
 - Install an ingress controller (e.g., Nginx Ingress Controller) in the Minikube cluster.
 - Verify the ingress controller is running and accessible.

### 5. Create Ingress Resource:
 - Write an ingress resource manifest to route external traffic to the static web application.
 - Configure advanced ingress rules for path-based routing and host-based routing (use at least two different hostnames and paths).
 - Implement TLS termination for secure connections.
 - Configure URL rewriting in the ingress resource to modify incoming URLs before they reach the backend services.
 - Enable sticky sessions to ensure that requests from the same client are directed to the same backend pod.

![alt text](<img/Screenshot from 2024-07-19 15-40-55.png>)

![alt text](<img/Screenshot from 2024-07-19 15-32-00.png>) 

![alt text](<img/Screenshot from 2024-07-19 15-32-28.png>)

### Deliverables:
 - Ingress controller installation commands/scripts

```bash
minikube start --driver=virtualbox --addons=ingress
```

 - Ingress resource YAML file with advanced routing, TLS configuration, URL rewriting, and sticky sessions

![alt text](<img/Screenshot from 2024-07-19 15-40-55.png>)

---
## Stage 3: Implementing Horizontal Pod Autoscaling

### 6. Configure Horizontal Pod Autoscaler:
 - Write a horizontal pod autoscaler (HPA) manifest to automatically scale the static web application pods based on CPU utilization.
 - Set thresholds for minimum and maximum pod replicas.

### 7. Stress Testing:
 - Perform stress testing to simulate traffic and validate the HPA configuration.
 - Monitor the scaling behavior and ensure the application scales up and down based on the load.

### Deliverables:
 - Horizontal pod autoscaler YAML file

![alt text](<img/Screenshot from 2024-07-19 15-44-11.png>)

 - Documentation or screenshots of the stress testing process and scaling behavior

    - for testing the horizontal scaling a load-balancer was created use the following code

```bash
# Created a load balancer pod
kubectl run -i --tty --rm load-generator --image=busybox --restart=Never -- /bin/sh

# in that pinged the url
while true; do wget -q -O- https://minikube.ip/live; done
```
![alt text](<img/Screenshot from 2024-07-19 15-53-49.png>)
![alt text](<img/Screenshot from 2024-07-19 11-46-49.png>)
![alt text](<img/Screenshot from 2024-07-19 11-52-10.png>)


---
## Stage 4: Final Validation and Cleanup

### 8. Final Validation:
 - Validate the ingress networking, URL rewriting, and sticky sessions configurations by accessing the web application through different hostnames and paths.
 - Verify the application's availability and performance during different load conditions.

### 9. Cleanup:
 - Provide commands or scripts to clean up the Kubernetes resources created during the project (deployments, services, ingress, HPA).

### Deliverables:
 - Final validation report documenting the testing process and results
 - Cleanup commands/scripts