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
`$newRelicLicenseKey = "[NEWRELIC_LICENSE_KEY]"`

Apply the extension
`Set-AzVMCustomScriptExtension -FileUri https://raw.githubusercontent.com/kidk/newrelic-azure-extension/master/windows/script.ps1 -Run script.ps1 -Argument "-newrelicLicenseKey $newRelicLicenseKey" -Name "newrelic-infra" -ResourceGroupName "Resource group name" -Location "Location name" -VMName "Virtual Machine name"`
