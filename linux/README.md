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
$newRelicLicenseKey = "[NEWRELIC_LICENSE_KEY]"`
```

Apply the extension
```
Set-AzVMCustomScriptExtension -FileUri https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/linux/script.sh -Run script.ps1 -Argument "$newRelicLicenseKey" -Name "newrelic-infra" -ResourceGroupName "myResourceGroup" -Location "myLocation" -VMName "myVirtualMachineName"`
```

### Virtual Machine Scale Sets

Set License key
```
$newRelicLicenseKey = "[NEWRELIC_LICENSE_KEY]"
```

Get information about the scale set
```
$vmss = Get-AzVmss -ResourceGroupName "myResourceGroup" -VMScaleSetName "myScaleSet"
```

Define Custom config
```
$customConfig = @{
  "fileUris" = (,"https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/linux/script.sh");
  "commandToExecute" = "bash script.sh $newRelicLicenseKey"
}
```

Add the Custom Script Extension to install New Relic Infrastucture
```
$vmss = Add-AzVmssExtension -VirtualMachineScaleSet $vmss -Name "newrelic-infra" -Publisher "Microsoft.Compute" -Type "CustomScriptExtension" -TypeHandlerVersion 1.9 -Setting $customConfig
```

Update the scale set and apply the Custom Script Extension to the VM instances
```
Update-AzVmss -VirtualMachineScaleSet $vmss -ResourceGroupName "myResourceGroup" -Name "myScaleSet"
```

If `Upgrade mode` is set to `Manual` you need to update each machine in your ScaleSet. Each new machine will automatically install New Relic.
```
Update-AzVmssInstance -ResourceGroupName "myResourceGroup" -VMScaleSetName "myScaleSet" -InstanceId "0"
```
