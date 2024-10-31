# Kubernetes Ultimate Cheat Sheet 📝🚀

<p align="center">
    <img width="646" alt="kubernetes" src="https://gist.github.com/user-attachments/assets/2d53c750-d6c6-459a-bc4a-76cea1236615">
</p>

## Control Plane Components 🛠️

The **Control Plane** manages the Kubernetes cluster and ensures that the desired state is maintained. It runs the following components:

### 1. **kube-apiserver**
   - **Definition**: The front-end for the Kubernetes control plane. It handles all API requests (CRUD operations on K8s objects like Pods and Services).
   - **Usage**: Exposes the Kubernetes API. All requests (kubectl commands) go through it.
### 2. **etcd**
   - **Definition**: A distributed key-value store used to store all the cluster data and state. It's the brain of the cluster where everything is stored.
   - **Usage**: Stores the configuration data of the cluster, including node and pod states.
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
### 11. **Job**
- **Definition**: A Kubernetes object that runs a task to completion. Jobs ensure that a specified number of Pods successfully terminate.
- **Usage**: For batch processing tasks or one-off jobs.

**Example Job YAML**:

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: my-job
spec:
  template:
    spec:
      containers:
      - name: my-job-container
        image: my-job-image
      restartPolicy: Never
```

---

### 12. **CronJob**
- **Definition**: A scheduled job that runs periodically based on a cron schedule. It's useful for running tasks at specific intervals.
- **Usage**: For routine tasks like backups or sending reports.

**Example CronJob YAML**:

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: my-cronjob
spec:
  schedule: "*/5 * * * *"  # Every 5 minutes
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: my-cronjob-container
            image: my-cronjob-image
          restartPolicy: Never
```

---

### 13. **StatefulSet**
- **Definition**: Manages stateful applications, providing guarantees about the ordering and uniqueness of Pods.
- **Usage**: For applications that require stable, unique network identifiers and persistent storage.

**Example StatefulSet YAML**:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-statefulset
spec:
  serviceName: "my-service"
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
      - name: my-container
        image: my-image
```

---

### 14. **NetworkPolicy**
- **Definition**: A specification for how groups of pods are allowed to communicate with each other and other network endpoints.
- **Usage**: Enforces network rules for Pods, enhancing security.

**Example NetworkPolicy YAML**:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-network-policy
spec:
  podSelector:
    matchLabels:
      app: my-app
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: my-other-app
```

---

### 15. **Horizontal Pod Autoscaler (HPA)**
- **Definition**: Automatically scales the number of Pods in a Deployment, ReplicaSet, or StatefulSet based on observed CPU utilization or other select metrics.
- **Usage**: Maintains performance under varying loads.

**Example HPA YAML**:

```yaml
apiVersion: autoscaling/v2beta2
kind: HorizontalPodAutoscaler
metadata:
  name: my-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-deployment
  minReplicas: 1
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: AverageUtilization
        averageUtilization: 50
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
## Volume & Storage Basics 📦

1. **PersistentVolume (PV)**: The actual storage resource in the cluster. Think of it as a "pool" of storage that Kubernetes knows about, but which isn't tied to any specific application until claimed.

2. **PersistentVolumeClaim (PVC)**: A request to claim a chunk of storage. When you create a PVC, it’s matched to an available PV that meets its requirements (size, access mode, etc.), making that storage available to the application.

3. **StorageClass**: A template defining how dynamic storage should be provisioned when needed. With a StorageClass, Kubernetes can automatically create PVs on demand, specifying storage type (e.g., SSD or HDD), IOPS, and other parameters. Useful for dynamic provisioning without pre-creating PVs.

4. **StatefulSet**: This workload controller manages stateful applications that need stable storage and unique identities across pods. A StatefulSet relies on PVCs for storage—each pod created by a StatefulSet can request a PVC, which in turn binds to a PV, ensuring persistent data storage even if the pod is restarted or rescheduled.

### Provisioning Types
- **Static Provisioning**:
  - Create a **PV** manually with specific settings.
  - Create a **PVC** that matches the PV to claim it.
  - Optionally, a **StatefulSet** can use this PVC to give each pod persistent storage.
  
- **Dynamic Provisioning**:
  - Define a **StorageClass** specifying desired storage characteristics.
  - Create a **PVC** with a reference to this StorageClass; Kubernetes provisions a PV automatically based on StorageClass parameters.
  - Optionally, a **StatefulSet** can use this dynamically created PVC, allowing Kubernetes to handle storage setup.

In summary, the **PV provides storage**, the **PVC claims that storage** for an application, the **StorageClass automates dynamic provisioning**, and the **StatefulSet orchestrates pods needing consistent, durable storage**.

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
