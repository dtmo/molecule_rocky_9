#!/bin/bash
set -eo pipefail

if getent passwd "$(logname)"; then
    userdel --force --remove "$(logname)"
fi

if getent passwd "$(cloud-init query system_info.default_user.name)"; then
    userdel --force --remove "$(cloud-init query system_info.default_user.name)"
fi

cloud-init clean --logs --machine-id --seed --configs all

poweroff
