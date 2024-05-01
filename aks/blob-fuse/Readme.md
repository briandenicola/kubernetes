# Details 

>> This does not work as of 5/1/24.  Workload Identies support requires that the storage account key is enabled on the storage account. If you do not wish to use the storage account key, you can only leveage a Managed Identity bound to AKS.  Workload Identities is not supported in this scenario

# Notes
* https://github.com/kubernetes-sigs/blob-csi-driver/issues/1351
* https://github.com/qxsch/Azure-Aks/blob/master/aks-blobfuse-mi/deployment.yaml
* https://github.com/kubernetes-sigs/blob-csi-driver/blob/master/docs/workload-identity-static-pv-mount.md

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
```~~
