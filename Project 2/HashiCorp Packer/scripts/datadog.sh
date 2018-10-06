#!/usr/bin/env bash
set -e
echo "Installing datadog-agent"
sudo DD_API_KEY=9289c8576640bde010aea49ae6f6f864 bash -c "$(curl -L https://raw.githubusercontent.com/DataDog/datadog-agent/master/cmd/agent/install_script.sh)"
echo "datadog-agent Installed"
