# Run with

param (
    [string]$newrelicLicenseKey
)

# Download
if ([Environment]::Is64BitProcess -ne [Environment]::Is64BitOperatingSystem)
{
    # 32bit
    $downloadUrl = "https://download.newrelic.com/infrastructure_agent/windows/386/newrelic-infra-386.msi"
} else {
    # 64bit
    $downloadUrl = "https://download.newrelic.com/infrastructure_agent/windows/newrelic-infra.msi"
}
Invoke-WebRequest -UseBasicParsing -uri $downloadUrl -outfile "newrelic-infra.msi"

# Install
msiexec.exe /qn /i ./newrelic-infra.msi GENERATE_CONFIG=true LICENSE_KEY="$newrelicLicenseKey"

# Start service
net start newrelic-infra
