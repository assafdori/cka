# Kubernetes Ultimate Cheat Sheet 📝🚀

## Control Plane Components 🛠️

The **Control Plane** manages the Kubernetes cluster and ensures that desired state is maintained. It runs the following components:

### 1. **kube-apiserver**:
   - **Definition**: The front-end for the Kubernetes control plane. It handles all the API requests (CRUD operations on K8s objects like Pods, Services).
   - **Usage**: Exposes the Kubernetes API. All requests (kubectl commands) go through it.

### 2. **etcd**:
   - **Definition**: A key-value store used to store all the cluster data and state. It's the brain of the cluster where everything is stored.
   - **Usage**: Stores the configuration data of the cluster, including node and pod states.

### 3. **kube-scheduler**:
   - **Definition**: Monitors for newly created Pods that have no assigned nodes and assigns them to nodes based on resource requirements, constraints, and policies.
   - **Usage**: Ensures Pods are scheduled onto the appropriate node.

### 4. **kube-controller-manager**:
   - **Definition**: Runs controller processes (like node controller, replication controller, etc.), ensuring the desired state of the cluster is maintained.
   - **Usage**: Watches the state of the cluster and makes changes to ensure the desired state matches the actual state (e.g., creating new Pods when Replicasets require it).

### 5. **cloud-controller-manager**:
   - **Definition**: If running on a cloud provider, manages cloud-specific controllers (like managing LoadBalancers, Nodes in the cloud).
   - **Usage**: Handles cluster integration with cloud services.

---

## Worker Node Components 🖥️

The **Worker Nodes** are where your application Pods are actually running. The worker nodes have the following components:

### 1. **kubelet**:
   - **Definition**: The agent running on each node, which ensures that containers are running in Pods.
   - **Usage**: Communicates with the kube-apiserver and ensures the node is running the required containers.

### 2. **kube-proxy**:
   - **Definition**: Handles networking, ensuring that Pods are accessible within and outside of the cluster.
   - **Usage**: Maintains network rules and routes traffic to the correct Pods.

### 3. **Container Runtime**:
   - **Definition**: The underlying software responsible for running containers (e.g., Docker, containerd, CRI-O).
   - **Usage**: Pulls and runs containers, providing the isolated environment for each Pod.

---

## 1. Pods

**Definition**: The smallest and simplest K8s object that represents a single instance of a running process.

**Usage**: Used to deploy containers.

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

## 2. ReplicaSet

**Definition**: Ensures a specified number of pod replicas are running at any time.

**Usage**: Maintains stable sets of replica Pods running in your cluster.

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

## 3. Deployment

**Definition**: Provides declarative updates to applications and handles scaling, rollouts, and rollbacks.

**Usage**: Rollout new versions of an app, or revert to a previous state.

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

## 4. Service

**Definition**: Abstracts the way Pods are accessed, enabling communication between Pods or external systems.

**Usage**: Exposes your Pods to internal/external traffic.

**Types of Services**:

- ClusterIP: Accessible only within the cluster (default).
- NodePort: Exposes service on each node's IP at a static port.
- LoadBalancer: Exposes service externally via cloud providers' load balancer.

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
  type: ClusterIP  # can be NodePort or LoadBalancer
```

## 5. ConfigMap

**Definition**: Allows you to decouple configuration files from container images, enabling easy configuration management.

**Usage**: Store non-sensitive configuration information.

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

## 6. Secret

**Definition**: Used to store sensitive data such as passwords or API keys.

**Usage**: Securely inject sensitive information into Pods.

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

## 7. Ingress

**Definition**: Manages external access to services, typically HTTP. Offers routing, load balancing, SSL termination, etc.

**Usage**: Expose HTTP and HTTPS routes from outside the cluster to services within the cluster.

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

## 8. PersistentVolume (PV)

**Definition**: A storage resource in the cluster, independent of any individual Pod that uses the PV.

**Usage**: Provision storage resources in K8s clusters.

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

## 9. PersistentVolumeClaim (PVC)

**Definition**: A request for storage by a user, binds to a PersistentVolume.

**Usage**: Request dynamically provisioned storage or existing PersistentVolume.

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

## 10. DaemonSet

**Definition**: Ensures that all (or some) nodes run a copy of a Pod.

**Usage**: For running background processes like log collectors, monitoring agents on every node.

**Example DaemonSet YAML**:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: my-daemonset
spec:
  selector:
    matchLabels:
      name: my-daemon
  template:
    metadata:
      labels:
        name: my-daemon
    spec:
      containers:
      - name: daemon-container
        image: nginx
```

## 11. StatefulSet

**Definition**: Manages the deployment and scaling of Pods, ensures a consistent identity and persistent storage.

**Usage**: Used for stateful applications like databases.

**Example StatefulSet YAML**:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: my-statefulset
spec:
  selector:
    matchLabels:
      app: my-app
  serviceName: "my-service"
  replicas: 3
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-container
        image: nginx
        volumeMounts:
        - name: my-storage
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: my-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
```

## 12. Job

**Definition**: Creates one or more Pods and ensures they successfully complete.

**Usage**: Used for short-lived tasks, like batch jobs.

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
      - name: pi
        image: perl
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
```

## 13. CronJob

**Definition**: Creates Jobs on a time-based schedule.

**Usage**: Automates tasks based on time (like scheduled database backups).

**Example CronJob YAML**:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-cronjob
spec:
  schedule: "*/1 * * * *"  # every minute
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: my-cron-container
            image: busybox
            args:
            - /bin/sh
            - -c
            - date; echo Hello from Kubernetes cron job
          restartPolicy: OnFailure
```

## 14. Horizontal Pod Autoscaler (HPA)

**Definition**: Automatically scales the number of pods based on observed CPU/memory utilization or other metrics.

**Usage**: Dynamic scaling to meet traffic demand.

**Example HPA YAML**:

```yaml
apiVersion: autoscaling/v1
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
  targetCPUUtilizationPercentage: 80
```

## 15. NetworkPolicy

**Definition**: Specifies how groups of Pods are allowed to communicate with each other and other network endpoints.

**Usage**: Restrict or allow traffic to Pods.

**Example NetworkPolicy YAML**:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-http
spec:
  podSelector:
    matchLabels:
      role: frontend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: backend
    ports:
    - protocol: TCP
      port: 80
```
