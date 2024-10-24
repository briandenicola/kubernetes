# Overview

* https://github.com/kubernetes-sigs/azurefile-csi-driver/issues/1763
* https://github.com/kubernetes-sigs/azurefile-csi-driver/blob/master/docs/workload-identity-static-pv-mount.md

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
kubectl describe pod azurefiles01 
kubectl -n default exec -it azurefiles01 -- cat hello world >> /mnt/files/sample.txt
```~~