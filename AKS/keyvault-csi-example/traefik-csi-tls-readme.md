# Prep

1. Create Key Vault - bjdkv-b25e5d
2. Create Managed Identity -  bjdtraefik-identity 
3. Assign Key Vault permissions to the Managed Identity -  bjdtraefik-identity
    * Get/List - Secrets
4. Upload pfx file to Certifcate store in Key Vault -  bjdkv-b25e5d
5. Create AKS cluster with CSI and Pod Identity add-ons - bjdk8s01

# Steps

1. ./identityv2-creation.sh bjdtraefik-identity k8s_rg k8s01dev default
2. helm repo add traefik https://helm.traefik.io/traefik
3. helm repo update
4. helm upgrade -i traefik traefik/traefik -f ./traefik-values.yaml --wait
5. kubectl apply -f ./traefik-csi-example.yaml
6. Update DNS record to point to Traefik's Service IP address
7. Test