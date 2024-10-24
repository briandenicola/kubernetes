# Overview
This is a simple example of how to use Azure Files with Kubernetes.


## Environment
```bash
    az login
    task up
    task deploy
```

## Clean up
```bash
task down
```

# Validate 
```
kubectl describe pod azurenfsfiles01 
kubectl -n default exec -it azurenfsfiles01 -- echo hello world >> /mnt/files/sample.txt
kubectl -n default exec -it azurenfsfiles02 -- cat /mnt/files/sample.txt
```~~