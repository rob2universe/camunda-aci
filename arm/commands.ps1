az group create --location southeastasia --name rg-camunda

# az deployment group create `
#   --name CamundaDeployment `
#   --resource-group rg-camunda `
#   --template-file .\filestorage.json `
#   --parameters .\filestorage.parameters.json

az deployment group create `
  --name CamundaDeployment `
  --resource-group rg-camunda `
  --template-file aci-camunda-ee.json `
  --parameters aci-camunda-ee.parameters.json

  # az container delete -g rg-camunda -n camunda-containers

  # az group delete --name rg-camunda