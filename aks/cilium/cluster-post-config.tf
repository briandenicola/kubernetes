# resource "azapi_update_resource" "this" {
#   depends_on = [
#     azurerm_kubernetes_cluster.this
#   ]

#   type        = "Microsoft.ContainerService/managedClusters@2023-05-02-preview"
#   resource_id = azurerm_kubernetes_cluster.this.id

#   body = jsonencode({
#     properties = {
#       serviceMeshProfile = {
#         istio = {
#           components = {
#             ingressGateways = [
#               {
#                 enabled = true
#                 mode = "Internal"
#               }
#             ]
#           }
#         }
#         mode = "Istio"
#       }
#     }
#   })
# }

# 
# Error: creating/updating 
# │ --------------------------------------------------------------------------------
# │ RESPONSE 409: 409 Conflict
# │ ERROR CODE: Conflict
# │ --------------------------------------------------------------------------------
# │ {
# │   "code": "Conflict",
# │   "details": null,
# │   "message": "Istio based Azure service mesh is incompatible with feature Cilium based Azure CNI.",
# │   "subcode": ""
# │ }
# │ --------------------------------------------------------------------------------
# │
# │