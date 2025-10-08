#!/bin/bash 

az feature list --namespace Microsoft.ContainerService --query "[?properties.state == 'Registered']" -o table