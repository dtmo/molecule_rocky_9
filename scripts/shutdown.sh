#!/bin/bash
set -eo pipefail

## Guidance from:
## https://systemd.io/BUILDING_IMAGES/
## https://lonesysadmin.net/2013/03/26/preparing-linux-template-vms/

# Remove /etc/machine-id
cloud-init clean --logs --machine-id --seed --configs all

# Remove the /var/lib/systemd/random-seed file
rm /var/lib/systemd/random-seed

# Remove /etc/hostname
rm /etc/hostname

# Remove SSH host keys
rm -f /etc/ssh/*key*

# Prevent writing shell history
set +o history

# Remove user accounts
if getent passwd "$(logname)"; then
    userdel --force --remove "$(logname)"
fi

if getent passwd "$(cloud-init query system_info.default_user.name)"; then
    userdel --force --remove "$(cloud-init query system_info.default_user.name)"
fi

# Remove logs
logrotate -f /etc/logrotate.conf
rm -f /var/log/*-????????
rm -rf /var/log/anaconda
rm -f /var/log/cloud-init-output.log
rm -f /var/log/cloud-init.log
truncate --size 0 /var/log/audit/audit.log
truncate --size 0 /var/log/btmp
truncate --size 0 /var/log/cron
truncate --size 0 /var/log/dnf.librepo.log
truncate --size 0 /var/log/dnf.log
truncate --size 0 /var/log/dnf.rpm.log
truncate --size 0 /var/log/hawkey.log
truncate --size 0 /var/log/lastlog
truncate --size 0 /var/log/maillog
truncate --size 0 /var/log/messages
truncate --size 0 /var/log/secure
truncate --size 0 /var/log/spooler
truncate --size 0 /var/log/tallylog
truncate --size 0 /var/log/wtmp

# Remove the udev persistent device rules
rm -f /etc/udev/rules.d/70*

# Clean /tmp
rm -rf /tmp/*
rm -rf /var/tmp/*

# Remove Kickstart record
rm -f ~root/anaconda-ks.cfg
rm -f ~root/original-ks.cfg

# Clean DNF
dnf clean all

# Zero out free space
cat /dev/zero > ~root/zeros.file || sync && rm ~root/zeros.file

# Shut down
poweroff
