#Details 

A quick demo to show how to use Azure Blob Fuse with Kubernetes Workload Identities.

Reference: https://github.com/kubernetes-sigs/blob-csi-driver/blob/master/docs/workload-identity-static-pv-mount.md
Requires: v1.23.3 of CSI Driver

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
    kubectl exec -it blobfuse01 -- ls /mnt/blob/sample.txt
```