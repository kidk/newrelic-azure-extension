#!/usr/bin/env bash

set -e

readonly OS_UNKNOWN=0
readonly OS_UBUNTU=1
readonly OS_DEBIAN=2
readonly OS_SUSE=3


# Check and set New Relic license key
if [ $# -eq 0 ]; then
    echo "Please supply your New Relic license key as the first argument"
    exit 1
fi
NR_LICENSE_KEY=$1

# Load in OS file and prepare vars for later usage
. /etc/os-release

# Check if License key is set in New Relic config file
if [ ! -z $(grep "license_key" "/etc/newrelic-infra.yml") ]; then
    echo "New Relic license key found.";
else
    echo "New Relic license key not found, installing ..."
    echo "license_key: $NR_LICENSE_KEY" | sudo tee -a /etc/newrelic-infra.yml
fi

# Check if GPG key is installed
case "$NAME" in
Ubuntu|Debian) # APT
    # Running this command multiple times has no effect
    curl https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | sudo apt-key add -
    ;;
Suse) # RPM
    # Running this command multiple times has no effect
    sudo rpm --import https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg
    ;;
esac

# Install repository file
case "$NAME" in
Ubuntu|Debian) # APT
    printf "deb [arch=amd64] https://download.newrelic.com/infrastructure_agent/linux/apt $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/newrelic-infra.list
    ;;
Suse) # RPM
    # Running this command multiple times has no effect
    sudo rpm --import https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg
    ;;
esac

# Update local repo and install
case "$NAME" in
Ubuntu|Debian) # APT
    sudo apt-get update
    sudo apt-get install newrelic-infra -y
    ;;
Suse) # RPM
    # Running this command multiple times has no effect
    sudo zypper -n ref -r newrelic-infra
    sudo zypper -n install newrelic-infra
    ;;
esac

# All done
exit 0
