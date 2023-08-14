# Quicksteps
## Complete Environment
```bash
    az login --scope https://graph.microsoft.com/.default
    task up
```

## Clean up
```bash
    task down
```
# Validate 
```
    kubectl get pods -A
```

# Notes
```
RESPONSE 501: 501 Not Implemented
│ ERROR CODE: PreviewFeatureNotRegistered
│ --------------------------------------------------------------------------------
│ {
│   "code": "PreviewFeatureNotRegistered",
│   "message": "Premium tier is not ready yet. We are working on it..."
│ }
│ -----------
```

# Backlog
- [ ] - Wait for support to come to the API