#!/bin/sh

# dhcphost=192.168.131.10
# branch=master
# subpath=github

sudo wget http://192.168.131.10/cloud-config.yml -O /home/core/cloud-config.yml

sudo coreos-install -d /dev/sda -C stable -c /home/core/cloud-config.yml

sudo eject

sudo reboot
