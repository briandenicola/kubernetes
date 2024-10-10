ingress_labels = {
    v1 = {
        label           = "v1"
        latest_revision = false
        traffic_weight  = 50
        revision_suffix = "viu34fx" //The revision suffix is a unique identifier for the revision for example: httpbin--viu34fx
    }
    v2 = {
        label           = "v2"
        latest_revision = true
        traffic_weight  = 50
        revision_suffix = null
    }
}

# ingress_labels = {
#     v1 = {
#         label           = "v1"
#         latest_revision = true
#         traffic_weight  = 100
#         revision_suffix = null
#     }
# }