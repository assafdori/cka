# Kubernetes Ultimate Cheat Sheet 📝🚀

## Control Plane Components 🛠️

The **Control Plane** manages the Kubernetes cluster and ensures that the desired state is maintained. It runs the following components:

### 1. **kube-apiserver**
   - **Definition**: The front-end for the Kubernetes control plane. It handles all API requests (CRUD operations on K8s objects like Pods and Services).
   - **Usage**: Exposes the Kubernetes API. All requests (kubectl commands) go through it.
   - **Commands**: 
     - `kubectl get pods`: List all pods.
     - `kubectl describe pod <pod-name>`: Get detailed info about a specific pod.

### 2. **etcd**
   - **Definition**: A distributed key-value store used to store all the cluster data and state. It's the brain of the cluster where everything is stored.
   - **Usage**: Stores the configuration data of the cluster, including node and pod states.
   - **Backup Command**: 
     ```bash
     etcdctl snapshot save <snapshot-file>
     ```

### 3. **kube-scheduler**
   - **Definition**: Monitors newly created Pods that have no assigned nodes and assigns them to nodes based on resource requirements, constraints, and policies.
   - **Usage**: Ensures Pods are scheduled onto the appropriate node.

### 4. **kube-controller-manager**
   - **Definition**: Runs controller processes (like node controller, replication controller, etc.) to ensure the desired state of the cluster is maintained.
   - **Usage**: Watches the state of the cluster and makes changes to ensure the desired state matches the actual state (e.g., creating new Pods when Replicasets require it).

### 5. **cloud-controller-manager**
   - **Definition**: If running on a cloud provider, manages cloud-specific controllers (like managing LoadBalancers and Nodes in the cloud).
   - **Usage**: Handles cluster integration with cloud services.

---

## Worker Node Components 🖥️

The **Worker Nodes** are where your application Pods are running. The worker nodes have the following components:

### 1. **kubelet**
   - **Definition**: The agent running on each node, which ensures that containers are running in Pods.
   - **Usage**: Communicates with the kube-apiserver and ensures the node is running the required containers.

### 2. **kube-proxy**
   - **Definition**: Handles networking, ensuring that Pods are accessible within and outside of the cluster.
   - **Usage**: Maintains network rules and routes traffic to the correct Pods.

### 3. **Container Runtime**
   - **Definition**: The underlying software responsible for running containers (e.g., Docker, containerd, CRI-O).
   - **Usage**: Pulls and runs containers, providing the isolated environment for each Pod.

---

## Kubernetes Objects

### 1. **Pods**
- **Definition**: The smallest and simplest K8s object that represents a single instance of a running process.
- **Usage**: Used to deploy containers.

**Example Pod YAML**:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
```

---

### 2. **ReplicaSet**
- **Definition**: Ensures a specified number of pod replicas are running at any time.
- **Usage**: Maintains stable sets of replica Pods running in your cluster.

**Example ReplicaSet YAML**:

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: my-replicaset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

---

### 3. **Deployment**
- **Definition**: Provides declarative updates to applications and handles scaling, rollouts, and rollbacks.
- **Usage**: Roll out new versions of an app or revert to a previous state.

**Example Deployment YAML**:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: nginx
        image: nginx:latest
```

---

### 4. **Service**
- **Definition**: Abstracts the way Pods are accessed, enabling communication between Pods or external systems.
- **Usage**: Exposes your Pods to internal/external traffic.

#### **Types of Services**:
1. **ClusterIP**:
   - **Definition**: The default service type. Exposes the service on a cluster-internal IP. 
   - **Usage**: Only accessible from within the cluster.
   - **Example**:
     ```yaml
     spec:
       type: ClusterIP
     ```

2. **NodePort**:
   - **Definition**: Exposes the service on each node's IP at a static port. 
   - **Usage**: Accessible from outside the cluster by requesting `<NodeIP>:<NodePort>`.
   - **Example**:
     ```yaml
     spec:
       type: NodePort
       ports:
       - port: 80
         targetPort: 8080
         nodePort: 30000
     ```

3. **LoadBalancer**:
   - **Definition**: Exposes the service externally using a cloud provider's load balancer.
   - **Usage**: Automatically provisions a load balancer and assigns a fixed external IP.
   - **Example**:
     ```yaml
     spec:
       type: LoadBalancer
       ports:
       - port: 80
         targetPort: 8080
     ```

**Example Service YAML**:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer  # can be ClusterIP or NodePort
```

---

### 5. **ConfigMap**
- **Definition**: Allows you to decouple configuration files from container images, enabling easy configuration management.
- **Usage**: Store non-sensitive configuration information.

**Example ConfigMap YAML**:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  app.properties: |
    key1=value1
    key2=value2
```

---

### 6. **Secret**
- **Definition**: Used to store sensitive data such as passwords or API keys.
- **Usage**: Securely inject sensitive information into Pods.

**Example Secret YAML**:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: YWRtaW4=  # base64 encoded
  password: MWYyZDFlMmU2N2Rm  # base64 encoded
```

---

### 7. **Ingress**
- **Definition**: Manages external access to services, typically HTTP. Offers routing, load balancing, and SSL termination.
- **Usage**: Exposes HTTP and HTTPS routes from outside the cluster to services within the cluster.

**Example Ingress YAML**:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: my-app.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

---

### 8. **PersistentVolume (PV)**
- **Definition**: A storage resource in the cluster, independent of any individual Pod that uses the PV.
- **Usage**: Provision storage resources in K8s clusters.

**Example PersistentVolume YAML**:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  hostPath:
    path: "/mnt/data"
```

---

### 9. **PersistentVolumeClaim (PVC)**
- **Definition**: A request for storage by a user, binds to a PersistentVolume.
- **Usage**: Request dynamically provisioned storage or an existing PersistentVolume.

**Example PersistentVolumeClaim YAML**:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: manual
```

---

### 10. **DaemonSet**
- **Definition**: Ensures that all (or some) nodes run a copy of a Pod.
- **Usage**: For running background processes like log collectors or monitoring agents on every node.

**Example DaemonSet YAML**:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemonset
spec:
  selector

:
    matchLabels:
      name: my-daemon
  template:
    metadata:
      labels:
        name: my-daemon
    spec:
      containers:
      - name: my-daemon
        image: my-daemon-image
```

---

## Monitoring and Debugging 🔍

### 1. **Logs**
- To view logs for a specific pod:
  ```bash
  kubectl logs <pod-name>
  ```
- For logs of all containers in a pod:
  ```bash
  kubectl logs <pod-name> --all-containers=true
  ```

### 2. **Get Resources**
- List all pods in a namespace:
  ```bash
  kubectl get pods -n <namespace>
  ```

### 3. **Describe Resources**
- To get detailed information about a resource:
  ```bash
  kubectl describe <resource-type> <resource-name>
  ```

### 4. **Exec into a Pod**
- To run commands inside a running pod:
  ```bash
  kubectl exec -it <pod-name> -- /bin/bash
  ```

### 5. **Port Forwarding**
- Forward a local port to a port on a pod:
  ```bash
  kubectl port-forward <pod-name> <local-port>:<pod-port>
  ```

### 6. **Get Events**
- To see recent events in the cluster:
  ```bash
  kubectl get events
  ```

---

## Networking Basics 🌐

- **ClusterIP**: Internal access only.
- **NodePort**: External access via node IP and port.
- **LoadBalancer**: External access via a cloud provider’s load balancer.
- **Ingress**: HTTP routing and external access management.

---

## Useful Commands 💡

1. **Get cluster information**:
   ```bash
   kubectl cluster-info
   ```

2. **Get nodes in the cluster**:
   ```bash
   kubectl get nodes
   ```

3. **Apply configurations**:
   ```bash
   kubectl apply -f <file>.yaml
   ```

4. **Delete resources**:
   ```bash
   kubectl delete <resource-type> <resource-name>
   ```

---

## Best Practices ✅

- Use **Namespaces** to isolate environments (e.g., dev, staging, production).
- Regularly backup **etcd**.
- Limit access using **RBAC** (Role-Based Access Control).
- Monitor resource usage with **Prometheus** and **Grafana**.
- Use **Helm** for package management.

---
