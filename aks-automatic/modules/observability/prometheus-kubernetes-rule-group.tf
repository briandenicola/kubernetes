resource "azurerm_monitor_alert_prometheus_rule_group" "prometheus_kubernetes_rule_groups" {
  count               = var.enable_managed_offerings ? 1 : 0
  name                = "${var.resource_name}-KubernetesRecordingRuleGroup"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  interval            = "PT1M"
  scopes              = [azurerm_monitor_workspace.this[0].id]
  rule_group_enabled  = true

  rule {
    enabled    = true
    record     = "node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate"
    expression = "sum by (cluster, namespace, pod, container) (  irate(container_cpu_usage_seconds_total{job=\"cadvisor\", image!=\"\"}[5m])) * on (cluster, namespace, pod) group_left(node) topk by (cluster, namespace, pod) (  1, max by(cluster, namespace, pod, node) (kube_pod_info{node!=\"\"}))"
  }
  rule {
    enabled    = true
    record     = "node_namespace_pod_container:container_memory_working_set_bytes"
    expression = "container_memory_working_set_bytes{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
  }
  rule {
    enabled    = true
    record     = "node_namespace_pod_container:container_memory_rss"
    expression = "container_memory_rss{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
  }
  rule {
    enabled    = true
    record     = "node_namespace_pod_container:container_memory_cache"
    expression = "container_memory_cache{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
  }
  rule {
    enabled    = true
    record     = "node_namespace_pod_container:container_memory_swap"
    expression = "container_memory_swap{job=\"cadvisor\", image!=\"\"}* on (namespace, pod) group_left(node) topk by(namespace, pod) (1,  max by(namespace, pod, node) (kube_pod_info{node!=\"\"}))"
  }
  rule {
    enabled    = true
    record     = "cluster:namespace:pod_memory:active:kube_pod_container_resource_requests"
    expression = "kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1))"
  }
  rule {
    enabled    = true
    record     = "namespace_memory:kube_pod_container_resource_requests:sum"
    expression = "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
  }
  rule {
    enabled    = true
    record     = "cluster:namespace:pod_cpu:active:kube_pod_container_resource_requests"
    expression = "kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1))"
  }
  rule {
    enabled    = true
    record     = "namespace_cpu:kube_pod_container_resource_requests:sum"
    expression = "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
  }
  rule {
    enabled    = true
    record     = "cluster:namespace:pod_memory:active:kube_pod_container_resource_limits"
    expression = "kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) (  (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1))"
  }
  rule {
    enabled    = true
    record     = "namespace_memory:kube_pod_container_resource_limits:sum"
    expression = "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
  }
  rule {
    enabled    = true
    record     = "cluster:namespace:pod_cpu:active:kube_pod_container_resource_limits"
    expression = "kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"}  * on (namespace, pod, cluster)group_left() max by (namespace, pod, cluster) ( (kube_pod_status_phase{phase=~\"Pending|Running\"} == 1) )"
  }
  rule {
    enabled    = true
    record     = "namespace_cpu:kube_pod_container_resource_limits:sum"
    expression = "sum by (namespace, cluster) (    sum by (namespace, pod, cluster) (        max by (namespace, pod, container, cluster) (          kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"}        ) * on(namespace, pod, cluster) group_left() max by (namespace, pod, cluster) (          kube_pod_status_phase{phase=~\"Pending|Running\"} == 1        )    ))"
  }
  rule {
    enabled    = true
    record     = "namespace_workload_pod:kube_pod_owner:relabel"
    expression = "max by (cluster, namespace, workload, pod) (  label_replace(    label_replace(      kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"ReplicaSet\"},      \"replicaset\", \"$1\", \"owner_name\", \"(.*)\"    ) * on(replicaset, namespace) group_left(owner_name) topk by(replicaset, namespace) (      1, max by (replicaset, namespace, owner_name) (        kube_replicaset_owner{job=\"kube-state-metrics\"}      )    ),    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))"
    labels = {
      workload_type = "deployment"
    }
  }
  rule {
    enabled    = true
    record     = "namespace_workload_pod:kube_pod_owner:relabel"
    expression = "max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"DaemonSet\"},    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))"
    labels = {
      workload_type = "daemonset"
    }
  }
  rule {
    enabled    = true
    record     = "namespace_workload_pod:kube_pod_owner:relabel"
    expression = "max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"StatefulSet\"},    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))"
    labels = {
      workload_type = "statefulset"
    }
  }
  rule {
    enabled    = true
    record     = "namespace_workload_pod:kube_pod_owner:relabel"
    expression = "max by (cluster, namespace, workload, pod) (  label_replace(    kube_pod_owner{job=\"kube-state-metrics\", owner_kind=\"Job\"},    \"workload\", \"$1\", \"owner_name\", \"(.*)\"  ))"
    labels = {
      workload_type = "job"
    }
  }
  rule {
    enabled    = true
    record     = ":node_memory_MemAvailable_bytes:sum"
    expression = "sum(  node_memory_MemAvailable_bytes{job=\"node\"} or  (    node_memory_Buffers_bytes{job=\"node\"} +    node_memory_Cached_bytes{job=\"node\"} +    node_memory_MemFree_bytes{job=\"node\"} +    node_memory_Slab_bytes{job=\"node\"}  )) by (cluster)"
  }
  rule {
    enabled    = true
    record     = "cluster:node_cpu:ratio_rate5m"
    expression = "sum(rate(node_cpu_seconds_total{job=\"node\",mode!=\"idle\",mode!=\"iowait\",mode!=\"steal\"}[5m])) by (cluster) /count(sum(node_cpu_seconds_total{job=\"node\"}) by (cluster, instance, cpu)) by (cluster)"
  }
}

resource "azurerm_monitor_alert_prometheus_rule_group" "prometheus_kubernetes_rule_groups_windows" {
  count               = var.enable_managed_offerings ? 1 : 0
  name                = "${var.resource_name}-KubernetesRecordingRuleGroup-Windows"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  interval            = "PT1M"
  scopes              = [azurerm_monitor_workspace.this[0].id]
  rule_group_enabled  = true

  rule {
    enabled    = true
    record     = "node:windows_node_filesystem_usage:"
    expression = "max by (instance,volume)((windows_logical_disk_size_bytes{job=\"windows-exporter\"} - windows_logical_disk_free_bytes{job=\"windows-exporter\"}) / windows_logical_disk_size_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_filesystem_avail:"
    expression = "max by (instance, volume) (windows_logical_disk_free_bytes{job=\"windows-exporter\"} / windows_logical_disk_size_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = ":windows_node_net_utilisation:sum_irate"
    expression = "sum(irate(windows_net_bytes_total{job=\"windows-exporter\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_net_utilisation:sum_irate"
    expression = "sum by (instance) ((irate(windows_net_bytes_total{job=\"windows-exporter\"}[5m])))"
  }
  rule {
    enabled    = true
    record     = ":windows_node_net_saturation:sum_irate"
    expression = "sum(irate(windows_net_packets_received_discarded_total{job=\"windows-exporter\"}[5m])) + sum(irate(windows_net_packets_outbound_discarded_total{job=\"windows-exporter\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_net_saturation:sum_irate"
    expression = "sum by (instance) ((irate(windows_net_packets_received_discarded_total{job=\"windows-exporter\"}[5m]) + irate(windows_net_packets_outbound_discarded_total{job=\"windows-exporter\"}[5m])))"
  }
  rule {
    enabled    = true
    record     = "windows_pod_container_available"
    expression = "windows_container_available{job=\"windows-exporter\", container_id != \"\"} * on(container_id) group_left(container, pod, namespace) max(kube_pod_container_info{job=\"kube-state-metrics\", container_id != \"\"}) by(container, container_id, pod, namespace)"
  }
  rule {
    enabled    = true
    record     = "windows_container_total_runtime"
    expression = "windows_container_cpu_usage_seconds_total{job=\"windows-exporter\", container_id != \"\"} * on(container_id) group_left(container, pod, namespace) max(kube_pod_container_info{job=\"kube-state-metrics\", container_id != \"\"}) by(container, container_id, pod, namespace)"
  }
  rule {
    enabled    = true
    record     = "windows_container_memory_usage"
    expression = "windows_container_memory_usage_commit_bytes{job=\"windows-exporter\", container_id != \"\"} * on(container_id) group_left(container, pod, namespace) max(kube_pod_container_info{job=\"kube-state-metrics\", container_id != \"\"}) by(container, container_id, pod, namespace)"
  }
  rule {
    enabled    = true
    record     = "windows_container_private_working_set_usage"
    expression = "windows_container_memory_usage_private_working_set_bytes{job=\"windows-exporter\", container_id != \"\"} * on(container_id) group_left(container, pod, namespace) max(kube_pod_container_info{job=\"kube-state-metrics\", container_id != \"\"}) by(container, container_id, pod, namespace)"
  }
  rule {
    enabled    = true
    record     = "windows_container_network_received_bytes_total"
    expression = "windows_container_network_receive_bytes_total{job=\"windows-exporter\", container_id != \"\"} * on(container_id) group_left(container, pod, namespace) max(kube_pod_container_info{job=\"kube-state-metrics\", container_id != \"\"}) by(container, container_id, pod, namespace)"
  }
  rule {
    enabled    = true
    record     = "windows_container_network_transmitted_bytes_total"
    expression = "windows_container_network_transmit_bytes_total{job=\"windows-exporter\", container_id != \"\"} * on(container_id) group_left(container, pod, namespace) max(kube_pod_container_info{job=\"kube-state-metrics\", container_id != \"\"}) by(container, container_id, pod, namespace)"
  }
  rule {
    enabled    = true
    record     = "kube_pod_windows_container_resource_memory_request"
    expression = "max by (namespace, pod, container) (kube_pod_container_resource_requests{resource=\"memory\",job=\"kube-state-metrics\"}) * on(container,pod,namespace) (windows_pod_container_available)"
  }
  rule {
    enabled    = true
    record     = "kube_pod_windows_container_resource_memory_limit"
    expression = "kube_pod_container_resource_limits{resource=\"memory\",job=\"kube-state-metrics\"} * on(container,pod,namespace) (windows_pod_container_available)"
  }
  rule {
    enabled    = true
    record     = "kube_pod_windows_container_resource_cpu_cores_request"
    expression = "max by (namespace, pod, container) ( kube_pod_container_resource_requests{resource=\"cpu\",job=\"kube-state-metrics\"}) * on(container,pod,namespace) (windows_pod_container_available)"
  }
  rule {
    enabled    = true
    record     = "kube_pod_windows_container_resource_cpu_cores_limit"
    expression = "kube_pod_container_resource_limits{resource=\"cpu\",job=\"kube-state-metrics\"} * on(container,pod,namespace) (windows_pod_container_available)"
  }
  rule {
    enabled    = true
    record     = "namespace_pod_container:windows_container_cpu_usage_seconds_total:sum_rate"
    expression = "sum by (namespace, pod, container) (rate(windows_container_total_runtime{}[5m]))"
  }
}
