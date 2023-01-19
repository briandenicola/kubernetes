.PHONY: help environment cluster creds refresh manifests

help :
	@echo "Usage:"
	@echo "   make environment      - create a cluster and deploy the apps "
	@echo "   make refresh          - updates infrastructure "
	@echo "   make clean            - delete the AKS cluster and cleans up "
	@echo "   make creds            - updates AKS credential files "
	@echo "   make manifests        - re-generates application manifests "

clean :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	cd infrastructure ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment: infra creds

infra : 
	terraform -chdir=./infrastructure init; terraform -chdir=./infrastructure apply -auto-approve

refresh :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks update -g $${RG} -n $${AKS} --api-server-authorized-ip-ranges "";\
	terraform -chdir=./infrastructure apply -auto-approve

creds : 
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks get-credentials -g $${RG} -n $${AKS} --overwrite-existing;\
	kubelogin convert-kubeconfig -l azurecli