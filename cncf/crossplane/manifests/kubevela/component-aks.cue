kubernetes: {
	annotations: {}
	attributes: workload: definition: {
		apiVersion: "containers.bjdazure.tech/v1alpha1"
		kind:       "ClusterClaim"
	}
	description: "AKS cluster"
	labels: {}
	type: "component"
}

template: {
	output: {
		apiVersion: "containers.bjdazure.tech/v1alpha1"
		kind:       "ClusterClaim"
		metadata: name: context.name
		spec: {
			compositionRef: {
				name:  parameter.cluster
			}
			id: context.name
			parameters: {
				location: parameter.location
				nodeCount:     parameter.nodeCount
				name: 	  parameter.name
			}
			writeConnectionSecretToRef: name: context.name
		}
	}
	outputs: {}
	parameter: {
		name:         *"aks01" | string
		nodeCount: 	  *2 | int
		location:     *"southcentralus" | string
	}
}

