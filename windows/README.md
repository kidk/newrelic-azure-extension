# New Relic Infrastructure Extension for Windows on Microsoft Azure

## Requirements

The script was tested on the following version:
* Windows Server 2019 Datacenter
* Windows Server 2016 Datacenter
* Windows Server 2012 R2 Datacenter

The installation requires an active internet connection.

## Installation

### Virtual Machine

Set License key
```
$newRelicLicenseKey = "[NEWRELIC_LICENSE_KEY]"`
```

Apply the extension
```
Set-AzVMCustomScriptExtension -FileUri https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/windows/script.ps1 -Run script.ps1 -Argument "-newrelicLicenseKey $newRelicLicenseKey" -Name "newrelic-infra" -ResourceGroupName "myResourceGroup" -Location "myLocation" -VMName "myVirtualMachineName"`
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
  "fileUris" = (,"https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/windows/script.ps1");
  "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File script.ps1 $newRelicLicenseKey"
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
