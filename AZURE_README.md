# Building for Azure

## Build VM Image

Build the VM image using Packer. This will generate a VHD in the specified storage account.

1. Install Packer CLI - https://learn.hashicorp.com/tutorials/packer/get-started-install-cli
2. Install Azure CLI - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
3. Login to your Azure account: `az login`
4. Using the Azure Portal, [create a storage account](https://ms.portal.azure.com/#create/Microsoft.StorageAccount) with default settings. You'll need to set the storage account name in the next step.
5. Modify the following variables in `parsec-nvidia-vhd.json`:

```
"tenant_id": "YOUR_TENANT_ID",
"subscription_id": "YOUR_SUBSCRIPTION_ID",
"resource_group_name": "YOUR_STORAGE_ACCOUNT_RESOURCE_GROUP_NAME",
"storageAccount": "YOUR_STORAGE_ACCOUNT_NAME",
```
6. Build the image in the "packer" folder: `packer build parsec-nvidia-vhd.json`. Once this is complete, you will see the VHD in your storage account under `Containers > system / Microsoft.Compute / Images / vhds`.

## Marketplace Assets

To create the offers in the Azure Marketplace, you'll need a few things:

1. createUiDefinition.json - this specifies the UI components that the customer will see in the Azure Portal for your offer. Modify this to add additional inputs. The outputs of this will be provided as parameters to the ARM template in the next step. You can preview what will be rendered using the [sandbox](https://portal.azure.com/?feature.customPortal=false#blade/Microsoft_Azure_CreateUIDef/SandboxBlade). More documentation [here](https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/create-uidefinition-overview).
2. mainTemplate.json - the ARM template that will do the actual deployment of the resources.
3. Powershell scripts - these are the Powershell scripts that will configure the team computers and install additional applications. These will be run by CustomScriptExtension.
4. SAS address to your VHD created previously: https://docs.microsoft.com/en-us/azure/marketplace/azure-vm-get-sas-uri#generate-the-sas-address.

We have provided a script to generate the zip package that the Partner Center will need when creating your offer. To create the package:

```
cd package
.\package.ps1
```

This will create a folder with `marketplacePackage.zip` in it. This is the zip file you'll need to submit for your offer.

## Test Deployments (Windows)

We have provided a script to test out the deployments as well. Create a `config.json` file with the following information filled out:

```
{
  "adminPass": "YOUR_PASSWORD",
  "location": "eastus",
  "teamId": "YOUR_TEAM_ID",
  "teamKey": "YOUR_TEAM_KEY",
  "userEmail": "OPTIONAL_EMAIL",    // optional
  "storageConnectionString": "YOUR_STORAGE_ACCOUNT_CONNECTION_STRING"
}
```

Then to deploy, run the command below. You can specify the resource group name (ex. MyTestResourceGroup) where the resources will be deployed into. Note that you will need to be logged into your Azure account (`az login`) first.

```
cd package
.\deployDev.ps1 MyTestResourceGroup
```
