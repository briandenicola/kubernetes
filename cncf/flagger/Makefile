.PHONY: help environment clean

help :
	@echo "Usage:"
	@echo "   make environment   - create a cluster and deploy the apps "
	@echo "   make check         - checks on current cluster state"
	@echo "   make edit          - Update podinfo image "
	@echo "   make refresh       - updates infrastructure "
	@echo "   make clean         - delete the AKS cluster and cleans up"

clean :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	cd ./infrastructure ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment : infra creds

refresh :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks update -g $${RG} -n $${AKS} --api-server-authorized-ip-ranges "";\
	terraform -chdir=./infrastructure apply -auto-approve

infra :
	terraform -chdir=./infrastructure init
	terraform -chdir=./infrastructure apply -auto-approve

creds :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli

edit :
	kubectl -n test set image deployment/podinfo podinfod=ghcr.io/stefanprodan/podinfo:6.0.1

check : 
	flux get all
	kubectl get service,pod,deployment
	kubectl -n istio-system get service,pod,deployment
	kubectl -n test get service,pod,deployment
	kubectl -n test describe canary/podinfo