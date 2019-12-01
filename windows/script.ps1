param ([Parameter(Mandatory=$true)]$newrelicLicenseKey)

write-host "Installing New Relic Infrastucture"

# Download
if ([Environment]::Is64BitProcess -ne [Environment]::Is64BitOperatingSystem)
{
    # 32bit
    $downloadUrl = "https://download.newrelic.com/infrastructure_agent/windows/386/newrelic-infra-386.msi"
    write-host "Downloading 32bit installation"
} else {
    # 64bit
    $downloadUrl = "https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi"
    write-host "Downloading 64bit installation"
}
Invoke-WebRequest -UseBasicParsing -uri $downloadUrl -outfile "newrelic-infra.msi"

# Install
write-host "Running installer"
msiexec.exe /qn /i newrelic-infra.msi GENERATE_CONFIG=true LICENSE_KEY="$newrelicLicenseKey"

# Start service
write-host "Starting service"
net start newrelic-infra

write-host "Done"
