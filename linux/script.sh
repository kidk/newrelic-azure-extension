#!/usr/bin/env bash
set -e

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

# Install gnupg dependency on Debian
if [ "$ID" = "debian" ]; then
    sudo apt-get install gnupg -y
fi

# Check if GPG key is installed
if [ "$ID" = "debian" ] || [ "$NAME" = "Ubuntu" ]; then
    curl https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | sudo apt-key add -
fi
if [ "$ID_LIKE" = "suse" ]; then
    sudo rpm --import https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg
fi

# Install repository file
if [ "$ID" = "debian" ] || [ "$NAME" = "Ubuntu" ]; then
    printf "deb [arch=amd64] https://download.newrelic.com/infrastructure_agent/linux/apt $VERSION_CODENAME main" | sudo tee /etc/apt/sources.list.d/newrelic-infra.list
fi
if [ "$ID" = "centos" ] || [ "$ID" = 'rhel' ]; then
    sudo curl -o /etc/yum.repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/yum/el/${VERSION_ID%%.*}/x86_64/newrelic-infra.repo
fi
if [ "$ID_LIKE" = "suse" ]; then
    . /etc/SuSE-release
    sudo curl -o /etc/zypp/repos.d/newrelic-infra.repo https://download.newrelic.com/infrastructure_agent/linux/zypp/sles/$VERSION.$PATCHLEVEL/x86_64/newrelic-infra.repo
fi

# Update local repo and install
if [ "$ID" = "debian" ] || [ "$NAME" = "Ubuntu" ]; then
    sudo apt-get update
    sudo apt-get install newrelic-infra -y
fi
if [ "$ID" = "centos" ] || [ "$ID" = 'rhel' ]; then
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='newrelic-infra'
    sudo yum install newrelic-infra -y
fi
if [ "$ID_LIKE" = "suse" ]; then
    sudo zypper -n ref -r newrelic-infra
    sudo zypper -n install newrelic-infra
fi

# All done
exit 0
