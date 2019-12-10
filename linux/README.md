# New Relic Infrastructure Extension for Linux on Microsoft Azure

## Requirements

The script was tested on the following version:
* RedHat 7-LVM
* CentOS 7.5
* Ubuntu 18.04 LTS
* Debian 10

The installation requires an active internet connection.

## Installation

### Virtual Machine

Set License key
```
newRelicLicenseKey = "[NEWRELIC_LICENSE_KEY]"`
```

Apply the extension
```
az vm extension set \
  --resource-group myResourceGroup \
  --vm-name myVirtualMachineName \
  --name customScript \
  --publisher Microsoft.Azure.Extensions \
  --protected-settings '{"fileUris": ["https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/linux/script.sh"],"commandToExecute": "bash script.sh $newRelicLicenseKey"}'
```

### Virtual Machine Scale Sets

Soon ..
