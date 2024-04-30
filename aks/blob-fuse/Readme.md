#Details 

A quick demo to show how to use Azure Blob Fuse with Kubernetes Workload Identities.

Reference: https://github.com/kubernetes-sigs/blob-csi-driver/blob/master/docs/workload-identity-static-pv-mount.md
Requires: v1.23.3 of greater of CSI Driver
    ``bash
    kubectl -n kube-system get pod -l "app=csi-blob-node" -o json | jq ".items[].spec.containers[].image"
    ```

## Environment
```bash
    az login --scope https://graph.microsoft.com/.default
    task up
    task deploy
```

## Clean up
```bash
task down
```

# Validate 
```
kubectl describe pod blobfuse01 
kubectl -n default exec -it blobfuse01 -- ls /mnt/blob/sample.txt
```