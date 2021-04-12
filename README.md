# Camunda Enterprise Azure Container Instance deployment

The scripts or the Azure resource manager templates in this project can be used to deploy the docker image provided by Camunda as an Azure Container instance.

To persist the embedded database file outside the container, a fileshare is created.

By default the [Camunda Platform Run](https://docs.camunda.org/manual/latest/user-guide/camunda-bpm-run/) distribution is used.

The project connects to the Camunda enterprise registry to download the image. The credentials for the registry need to be provided as parameters.

## Usage

- Clone the project or download the two files:
   - [*./arm/aci-camunda-ee.json*](./arm/aci-camunda-ee.json)   
   - [*./arm/aci-camunda-ee.parameters.json*](./arm/aci-camunda-ee.parameters.json) 
- Adjust the parameters in [*./arm/aci-camunda-ee.parameters.json*](./arm/aci-camunda-ee.parameters.json) according to your wishes.
- From Azure Shell 
   1. run:  `az login`    
   2. then create the resource group e.g. using (adjust location as needed):    
`az group create --location southeastasia --name rg-camunda`
   1. and finally create the resources. In the folder where the files reside run:  
`az deployment group create --name CamundaDeployment --resource-group rg-camunda --template-file aci-camunda-ee.json --parameters aci-camunda-ee.parameters.json`  

Once the container instance is running, the web application will be accessible under the  
*http://[dnsname].[region].azurecontainer.io:8080*  
e.g. http://mycamundadns.southeastasia.azurecontainer.io:8080