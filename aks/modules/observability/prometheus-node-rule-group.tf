
resource "azurerm_monitor_alert_prometheus_rule_group" "prometheus_node_recording_rule_group" {
  count               = var.enable_managed_offerings ? 1 : 0
  name                = "${var.resource_name}-NodeRecordingRuleGroup"  
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  interval            = "PT1M"
  scopes              = [azurerm_monitor_workspace.this[0].id]
  rule_group_enabled  = true

  rule {
    enabled    = true
    record     = "instance:node_num_cpu:sum"
    expression = "count without (cpu, mode) (node_cpu_seconds_total{job=\"node\",mode=\"idle\"})"
  }
  rule {
    enabled    = true
    record     = "instance:node_cpu_utilisation:rate5m"
    expression = "1 - avg without (cpu) (sum without (mode) (rate(node_cpu_seconds_total{job=\"node\", mode=~\"idle|iowait|steal\"}[5m])))"
  }
  rule {
    enabled    = true
    record     = "instance:node_load1_per_cpu:ratio"
    expression = "(  node_load1{job=\"node\"}/  instance:node_num_cpu:sum{job=\"node\"})"
  }
  rule {
    enabled    = true
    record     = "instance:node_memory_utilisation:ratio"
    expression = "1 - ((node_memory_MemAvailable_bytes{job=\"node\"} or (node_memory_Buffers_bytes{job=\"node\"} + node_memory_Cached_bytes{job=\"node\"} + node_memory_MemFree_bytes{job=\"node\"} + node_memory_Slab_bytes{job=\"node\"}))/  node_memory_MemTotal_bytes{job=\"node\"})"
  }
  rule {
    enabled    = true
    record     = "instance:node_vmstat_pgmajfault:rate5m"
    expression = "rate(node_vmstat_pgmajfault{job=\"node\"}[5m])"
  }
  rule {
    enabled    = true
    record     = "instance_device:node_disk_io_time_seconds:rate5m"
    expression = "rate(node_disk_io_time_seconds_total{job=\"node\", device!=\"\"}[5m])"
  }
  rule {
    enabled    = true
    record     = "instance_device:node_disk_io_time_weighted_seconds:rate5m"
    expression = "rate(node_disk_io_time_weighted_seconds_total{job=\"node\", device!=\"\"}[5m])"
  }
  rule {
    enabled    = true
    record     = "instance:node_network_receive_bytes_excluding_lo:rate5m"
    expression = "sum without (device) (  rate(node_network_receive_bytes_total{job=\"node\", device!=\"lo\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "instance:node_network_transmit_bytes_excluding_lo:rate5m"
    expression = "sum without (device) (  rate(node_network_transmit_bytes_total{job=\"node\", device!=\"lo\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "instance:node_network_receive_drop_excluding_lo:rate5m"
    expression = "sum without (device) (  rate(node_network_receive_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "instance:node_network_transmit_drop_excluding_lo:rate5m"
    expression = "sum without (device) (  rate(node_network_transmit_drop_total{job=\"node\", device!=\"lo\"}[5m]))"
  }
}

resource "azurerm_monitor_alert_prometheus_rule_group" "prometheus_node_recording_rule_group_windows" {
  count               = var.enable_managed_offerings ? 1 : 0  
  name                = "${var.resource_name}-NodeRecordingRuleGroup-Windows"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  interval            = "PT1M"
  scopes              = [azurerm_monitor_workspace.this[0].id]
  rule_group_enabled  = true

  rule {
    enabled    = true
    record     = "node:windows_node:sum"
    expression = "count (windows_system_system_up_time{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_num_cpu:sum"
    expression = "count by (instance) (sum by (instance, core) (windows_cpu_time_total{job=\"windows-exporter\"}))"
  }
  rule {
    enabled    = true
    record     = ":windows_node_cpu_utilisation:avg5m"
    expression = "1 - avg(rate(windows_cpu_time_total{job=\"windows-exporter\",mode=\"idle\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_cpu_utilisation:avg5m"
    expression = "1 - avg by (instance) (rate(windows_cpu_time_total{job=\"windows-exporter\",mode=\"idle\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = ":windows_node_memory_utilisation:"
    expression = "1 -sum(windows_memory_available_bytes{job=\"windows-exporter\"})/sum(windows_os_visible_memory_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = ":windows_node_memory_MemFreeCached_bytes:sum"
    expression = "sum(windows_memory_available_bytes{job=\"windows-exporter\"} + windows_memory_cache_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_memory_totalCached_bytes:sum"
    expression = "(windows_memory_cache_bytes{job=\"windows-exporter\"} + windows_memory_modified_page_list_bytes{job=\"windows-exporter\"} + windows_memory_standby_cache_core_bytes{job=\"windows-exporter\"} + windows_memory_standby_cache_normal_priority_bytes{job=\"windows-exporter\"} + windows_memory_standby_cache_reserve_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = ":windows_node_memory_MemTotal_bytes:sum"
    expression = "sum(windows_os_visible_memory_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_memory_bytes_available:sum"
    expression = "sum by (instance) ((windows_memory_available_bytes{job=\"windows-exporter\"}))"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_memory_bytes_total:sum"
    expression = "sum by (instance) (windows_os_visible_memory_bytes{job=\"windows-exporter\"})"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_memory_utilisation:ratio"
    expression = "(node:windows_node_memory_bytes_total:sum - node:windows_node_memory_bytes_available:sum) / scalar(sum(node:windows_node_memory_bytes_total:sum))"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_memory_utilisation:"
    expression = "1 - (node:windows_node_memory_bytes_available:sum / node:windows_node_memory_bytes_total:sum)"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_memory_swap_io_pages:irate"
    expression = "irate(windows_memory_swap_page_operations_total{job=\"windows-exporter\"}[5m])"
  }
  rule {
    enabled    = true
    record     = ":windows_node_disk_utilisation:avg_irate"
    expression = "avg(irate(windows_logical_disk_read_seconds_total{job=\"windows-exporter\"}[5m]) + irate(windows_logical_disk_write_seconds_total{job=\"windows-exporter\"}[5m]))"
  }
  rule {
    enabled    = true
    record     = "node:windows_node_disk_utilisation:avg_irate"
    expression = "avg by (instance) ((irate(windows_logical_disk_read_seconds_total{job=\"windows-exporter\"}[5m]) + irate(windows_logical_disk_write_seconds_total{job=\"windows-exporter\"}[5m])))"
  }
}

