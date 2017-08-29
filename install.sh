#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"
prefix="$1"
[[ -z "$prefix" ]] && prefix="/usr/local"

mkdir -p "$prefix/lib/systemd/system-generators"
mkdir -p "$prefix/bin"

cp "$script_dir/crypttab-umount-generator.sh" "$prefix/lib/systemd/system-generators"
sed -i "s|__PREFIX__|$prefix|g" "$prefix/lib/systemd/system-generators/crypttab-umount-generator.sh"
chown root:root "$prefix/lib/systemd/system-generators/crypttab-umount-generator.sh"
chmod 750 "$prefix/lib/systemd/system-generators/crypttab-umount-generator.sh"

cp "$script_dir/crypttab-umount.sh" "$prefix/bin"
chown root:root "$prefix/bin/crypttab-umount.sh"
chmod 750 "$prefix/bin/crypttab-umount.sh"

systemctl daemon-reload
