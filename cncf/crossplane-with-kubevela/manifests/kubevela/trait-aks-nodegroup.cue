aksnodepool: {
	annotations: {}
	attributes: {
		appliesToWorkloads: ["kubernetes"]
		conflictsWith:      []
		podDisruptive:      false
		workloadRefPath:    ""
	}
	description: "AKS nodegroup"
	labels:      {}
	type:        "trait"
}

template: {
	outputs: aksnodepool: {
		apiVersion: "containerservice.azure.upbound.io/v1beta1"
		kind:       "KubernetesClusterNodePool"
		metadata: {
			name: context.name + "-" + parameter.clusterName
		}
		spec: forProvider: {
			kubernetesClusterIdSelector: name: parameter.clusterName
			vnetSubnetIdRef: name: parameter.vnetName
			podSubnetIdRef: name: parameter.subnetName
			name: context.name
			nodeCount: 2
			vmSize: parameter.instanceType
			enableAutoScaling: true
  			mode: "User"
  			osSku: "CBLMariner"
  			osDiskSizeGb: 30
  			minCount: 3
  			maxCount: 6
		}
	}
	parameter: {
		clusterName:  string
		instanceType: *"standard_b4ms" | string
		vnetName:     string
		subnetName:   string
	}
}

