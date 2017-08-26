#!/bin/bash

script_dir="$( cd "$( dirname "$0" )" && pwd )"
prefix="$1"
[[ -z "$prefix" ]] && prefix="/usr/local"

mkdir -p "$prefix/lib/systemd/system-generators"
cp "$script_dir/crypttab-umount-generator.sh" "$prefix/lib/systemd/system-generators"

mkdir -p "$prefix/bin"
cp "$script_dir/crypttab-umount.sh" "$prefix/bin"

sed -i "s|__PREFIX__|$prefix|g" "$prefix/lib/systemd/system-generators/crypttab-umount-generator.sh"
systemctl daemon-reload
