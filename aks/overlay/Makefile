.PHONY: help environment clean

help :
	@echo "Usage:"
	@echo "   make environment   - create a cluster and deploy the apps "
	@echo "   make clean         - delete the AKS cluster and cleans up"

clean :
	export RG=`terraform output -raw AKS_RESOURCE_GROUP` ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment : infra creds

infra :
	terraform init
	terraform apply -auto-approve

creds :
	export RG=`terraform output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform output -raw AKS_CLUSTER_NAME` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli
