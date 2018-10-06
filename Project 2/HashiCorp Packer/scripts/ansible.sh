#!/usr/bin/env bash
set -e

echo "Installing Ansible"
sudo apt-get -y update
sudo apt-get -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get -y update
sudo apt-get -y install ansible
sudo ansible --version -y
echo "Ansible installed"
