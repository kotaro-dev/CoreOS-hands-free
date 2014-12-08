#!/bin/sh

dhcphost=raw.github.com/kotaro-dev/CoreOS-hands-free/github/
branch=master
subpath=github

sudo wget http://${dhcphost}${branch}/${subpath}/cloud-config.yml -O /home/core/cloud-config.yml

sudo coreos-install -d /dev/sda -C stable -c cloud-config.yml

sudo eject

sudo reboot
