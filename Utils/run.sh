#!/bin/bash

kubectl run --generator=run-pod/v1 --image bjd145/utils -it --rm utils -- bash 
