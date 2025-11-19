resource "azurerm_monitor_alert_prometheus_rule_group" "ux_recording_rule_group" {
  count               = var.enable_managed_offerings ? 1 : 0  
  name                = "${var.resource_name}-UXRecordingRuleGroup"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  interval            = "PT1M"
  scopes              = [azurerm_monitor_workspace.this[0].id]
  rule_group_enabled  = true

  rule {
    enabled    = true
    record     = "ux:pod_cpu_usage:sum_irate"
    expression = "(sum by (namespace, pod, cluster, microsoft_resourceid) (\n\tirate(container_cpu_usage_seconds_total{container != \"\", pod != \"\", job = \"cadvisor\"}[5m])\n)) * on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n(max by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (kube_pod_info{pod != \"\", job = \"kube-state-metrics\"}))"
  }
  rule {
    enabled    = true
    record     = "ux:controller_cpu_usage:sum_irate"
    expression = "sum by (namespace, node, cluster, created_by_name, created_by_kind, microsoft_resourceid) (\nux:pod_cpu_usage:sum_irate\n)\n"
  }
  rule {
    enabled    = true
    record     = "ux:pod_workingset_memory:sum"
    expression = "(\n\t    sum by (namespace, pod, cluster, microsoft_resourceid) (\n\t\tcontainer_memory_working_set_bytes{container != \"\", pod != \"\", job = \"cadvisor\"}\n\t    )\n\t) * on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n(max by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (kube_pod_info{pod != \"\", job = \"kube-state-metrics\"}))"
  }
  rule {
    enabled    = true
    record     = "ux:controller_workingset_memory:sum"
    expression = "sum by (namespace, node, cluster, created_by_name, created_by_kind, microsoft_resourceid) (\nux:pod_workingset_memory:sum\n)"
  }
  rule {
    enabled    = true
    record     = "ux:pod_rss_memory:sum"
    expression = "(\n\t    sum by (namespace, pod, cluster, microsoft_resourceid) (\n\t\tcontainer_memory_rss{container != \"\", pod != \"\", job = \"cadvisor\"}\n\t    )\n\t) * on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n(max by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (kube_pod_info{pod != \"\", job = \"kube-state-metrics\"}))"
  }
  rule {
    enabled    = true
    record     = "ux:controller_rss_memory:sum"
    expression = "sum by (namespace, node, cluster, created_by_name, created_by_kind, microsoft_resourceid) (\nux:pod_rss_memory:sum\n)"
  }
  rule {
    enabled    = true
    record     = "ux:pod_container_count:sum"
    expression = "sum by (node, created_by_name, created_by_kind, namespace, cluster, pod, microsoft_resourceid) (\n(\n(\nsum by (container, pod, namespace, cluster, microsoft_resourceid) (kube_pod_container_info{container != \"\", pod != \"\", container_id != \"\", job = \"kube-state-metrics\"})\nor sum by (container, pod, namespace, cluster, microsoft_resourceid) (kube_pod_init_container_info{container != \"\", pod != \"\", container_id != \"\", job = \"kube-state-metrics\"})\n)\n* on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n(\nmax by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (\n\tkube_pod_info{pod != \"\", job = \"kube-state-metrics\"}\n)\n)\n)\n\n)"
  }
  rule {
    enabled    = true
    record     = "ux:controller_container_count:sum"
    expression = "sum by (node, created_by_name, created_by_kind, namespace, cluster, microsoft_resourceid) (\nux:pod_container_count:sum\n)"
  }
  rule {
    enabled    = true
    record     = "ux:pod_container_restarts:max"
    expression = "max by (node, created_by_name, created_by_kind, namespace, cluster, pod, microsoft_resourceid) (\n(\n(\nmax by (container, pod, namespace, cluster, microsoft_resourceid) (kube_pod_container_status_restarts_total{container != \"\", pod != \"\", job = \"kube-state-metrics\"})\nor sum by (container, pod, namespace, cluster, microsoft_resourceid) (kube_pod_init_status_restarts_total{container != \"\", pod != \"\", job = \"kube-state-metrics\"})\n)\n* on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n(\nmax by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (\n\tkube_pod_info{pod != \"\", job = \"kube-state-metrics\"}\n)\n)\n)\n\n)"
  }
  rule {
    enabled    = true
    record     = "ux:controller_container_restarts:max"
    expression = "max by (node, created_by_name, created_by_kind, namespace, cluster, microsoft_resourceid) (\nux:pod_container_restarts:max\n)"
  }
  rule {
    enabled    = true
    record     = "ux:pod_resource_limit:sum"
    expression = "(sum by (cluster, pod, namespace, resource, microsoft_resourceid) (\n(\n\tmax by (cluster, microsoft_resourceid, pod, container, namespace, resource)\n\t (kube_pod_container_resource_limits{container != \"\", pod != \"\", job = \"kube-state-metrics\"})\n)\n)unless (count by (pod, namespace, cluster, resource, microsoft_resourceid)\n\t(kube_pod_container_resource_limits{container != \"\", pod != \"\", job = \"kube-state-metrics\"})\n!= on (pod, namespace, cluster, microsoft_resourceid) group_left()\n sum by (pod, namespace, cluster, microsoft_resourceid)\n (kube_pod_container_info{container != \"\", pod != \"\", job = \"kube-state-metrics\"}) \n)\n\n)* on (namespace, pod, cluster, microsoft_resourceid) group_left (node, created_by_kind, created_by_name)\n(\n\tkube_pod_info{pod != \"\", job = \"kube-state-metrics\"}\n)"
  }
  rule {
    enabled    = true
    record     = "ux:controller_resource_limit:sum"
    expression = "sum by (cluster, namespace, created_by_name, created_by_kind, node, resource, microsoft_resourceid) (\nux:pod_resource_limit:sum\n)"
  }
  rule {
    enabled    = true
    record     = "ux:controller_pod_phase_count:sum"
    expression = "sum by (cluster, phase, node, created_by_kind, created_by_name, namespace, microsoft_resourceid) ( (\n(kube_pod_status_phase{job=\"kube-state-metrics\",pod!=\"\"})\n or (label_replace((count(kube_pod_deletion_timestamp{job=\"kube-state-metrics\",pod!=\"\"}) by (namespace, pod, cluster, microsoft_resourceid) * count(kube_pod_status_reason{reason=\"NodeLost\", job=\"kube-state-metrics\"} == 0) by (namespace, pod, cluster, microsoft_resourceid)), \"phase\", \"terminating\", \"\", \"\"))) * on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n(\nmax by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (\nkube_pod_info{job=\"kube-state-metrics\",pod!=\"\"}\n)\n)\n)"
  }
  rule {
    enabled    = true
    record     = "ux:cluster_pod_phase_count:sum"
    expression = "sum by (cluster, phase, node, namespace, microsoft_resourceid) (\nux:controller_pod_phase_count:sum\n)"
  }
  rule {
    enabled    = true
    record     = "ux:node_cpu_usage:sum_irate"
    expression = "sum by (instance, cluster, microsoft_resourceid) (\n(1 - irate(node_cpu_seconds_total{job=\"node\", mode=\"idle\"}[5m]))\n)"
  }
  rule {
    enabled    = true
    record     = "ux:node_memory_usage:sum"
    expression = "sum by (instance, cluster, microsoft_resourceid) ((\nnode_memory_MemTotal_bytes{job = \"node\"}\n- node_memory_MemFree_bytes{job = \"node\"} \n- node_memory_cached_bytes{job = \"node\"}\n- node_memory_buffers_bytes{job = \"node\"}\n))"
  }
  rule {
    enabled    = true
    record     = "ux:node_network_receive_drop_total:sum_irate"
    expression = "sum by (instance, cluster, microsoft_resourceid) (irate(node_network_receive_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "ux:node_network_transmit_drop_total:sum_irate"
    expression = "sum by (instance, cluster, microsoft_resourceid) (irate(node_network_transmit_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
  }
}

resource "azurerm_monitor_alert_prometheus_rule_group" "ux_recording_rule_group_windows" {
  count               = var.enable_managed_offerings ? 1 : 0
  name                = "${var.resource_name}-UXRecordingRuleGroup-Windows"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  interval            = "PT1M"
  scopes              = [azurerm_monitor_workspace.this[0].id]
  rule_group_enabled  = true

  rule {
    enabled    = true
    record     = "ux:pod_cpu_usage_windows:sum_irate"
    expression = "sum by (cluster, pod, namespace, node, created_by_kind, created_by_name, microsoft_resourceid) (\n\t(\n\t\tmax by (instance, container_id, cluster, microsoft_resourceid) (\n\t\t\tirate(windows_container_cpu_usage_seconds_total{ container_id != \"\", job = \"windows-exporter\"}[5m])\n\t\t) * on (container_id, cluster, microsoft_resourceid) group_left (container, pod, namespace) (\n\t\t\tmax by (container, container_id, pod, namespace, cluster, microsoft_resourceid) (\n\t\t\t\tkube_pod_container_info{container != \"\", pod != \"\", container_id != \"\", job = \"kube-state-metrics\"}\n\t\t\t)\n\t\t)\n\t) * on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n\t(\n\t\tmax by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (\n\t\t  kube_pod_info{ pod != \"\", job = \"kube-state-metrics\"}\n\t\t)\n\t)\n)"
  }
  rule {
    enabled    = true
    record     = "ux:controller_cpu_usage_windows:sum_irate"
    expression = "sum by (namespace, node, cluster, created_by_name, created_by_kind, microsoft_resourceid) (\nux:pod_cpu_usage_windows:sum_irate\n)\n"
  }
  rule {
    enabled    = true
    record     = "ux:pod_workingset_memory_windows:sum"
    expression = "sum by (cluster, pod, namespace, node, created_by_kind, created_by_name, microsoft_resourceid) (\n\t(\n\t\tmax by (instance, container_id, cluster, microsoft_resourceid) (\n\t\t\twindows_container_memory_usage_private_working_set_bytes{ container_id != \"\", job = \"windows-exporter\"}\n\t\t) * on (container_id, cluster, microsoft_resourceid) group_left (container, pod, namespace) (\n\t\t\tmax by (container, container_id, pod, namespace, cluster, microsoft_resourceid) (\n\t\t\t\tkube_pod_container_info{container != \"\", pod != \"\", container_id != \"\", job = \"kube-state-metrics\"}\n\t\t\t)\n\t\t)\n\t) * on (pod, namespace, cluster, microsoft_resourceid) group_left (node, created_by_name, created_by_kind)\n\t(\n\t\tmax by (node, created_by_name, created_by_kind, pod, namespace, cluster, microsoft_resourceid) (\n\t\t  kube_pod_info{ pod != \"\", job = \"kube-state-metrics\"}\n\t\t)\n\t)\n)"
  }
  rule {
    enabled    = true
    record     = "ux:controller_workingset_memory_windows:sum"
    expression = "sum by (namespace, node, cluster, created_by_name, created_by_kind, microsoft_resourceid) (\nux:pod_workingset_memory_windows:sum\n)"
  }
  rule {
    enabled    = true
    record     = "ux:node_cpu_usage_windows:sum_irate"
    expression = "sum by (instance, cluster, microsoft_resourceid) (\n(1 - irate(windows_cpu_time_total{job=\"windows-exporter\", mode=\"idle\"}[5m]))\n)"
  }
  rule {
    enabled    = true
    record     = "ux:node_memory_usage_windows:sum"
    expression = "sum by (instance, cluster, microsoft_resourceid) ((\nwindows_os_visible_memory_bytes{job = \"windows-exporter\"}\n- windows_memory_available_bytes{job = \"windows-exporter\"}\n))"
  }
  rule {
    enabled    = true
    record     = "ux:node_network_packets_received_drop_total_windows:sum_irate"
    expression = "sum by (instance, cluster, microsoft_resourceid) (irate(windows_net_packets_received_discarded_total{job=\"windows-exporter\", device!=\"lo\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "ux:node_network_packets_outbound_drop_total_windows:sum_irate"
    expression = "sum by (instance, cluster, microsoft_resourceid) (irate(windows_net_packets_outbound_discarded_total{job=\"windows-exporter\", device!=\"lo\"}[5m]))"
  }
}
