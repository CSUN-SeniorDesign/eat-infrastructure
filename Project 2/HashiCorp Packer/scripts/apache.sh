#!/usr/bin/env bash
set -e

echo "Installing apache2"
sudo apt-get update -y
sudo apt-get remove libaprutil1
sudo apt-get autoremove
sudo apt-get install apache2 -y
sudo apt-get update -y
echo "apache2 installed"
