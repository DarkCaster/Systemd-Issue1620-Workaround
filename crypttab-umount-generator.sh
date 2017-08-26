#!/bin/bash
#

# This systemd-generator script creates dynamic unit with the following logic:
# It will start after all devices from /etc/crypttab and stop before it.
# On stop it will try to unmount all devices in /etc/crypttab except swap and root-fs

output_dir="$3"

deps=()
deps_cnt=0

add_device() {
  deps[$deps_cnt]="$1"
  (( deps_cnt += 1 ))
}

while read -r devname line_end
do
  add_device "dev-mapper-${devname}.device"
done < "/etc/crypttab"

echo "[Unit]" > "$output_dir/crypttab-umount.service"
echo "Description=Unmount crypttab devices on shutdown" >> "$output_dir/crypttab-umount.service"
echo "DefaultDependencies=no" >> "$output_dir/crypttab-umount.service"
echo "Requires=local-fs.target cryptsetup.target" >> "$output_dir/crypttab-umount.service"
echo "After=local-fs.target cryptsetup.target ${deps[*]}" >> "$output_dir/crypttab-umount.service"
echo "Before=basic.target" >> "$output_dir/crypttab-umount.service"
echo "[Service]" >> "$output_dir/crypttab-umount.service"
echo "Type=oneshot" >> "$output_dir/crypttab-umount.service"
echo "RemainAfterExit=true" >> "$output_dir/crypttab-umount.service"
echo "ExecStart=/bin/true" >> "$output_dir/crypttab-umount.service"
echo "ExecStop=__PREFIX__/bin/crypttab-umount.sh" >> "$output_dir/crypttab-umount.service"
echo "[Install]" >> "$output_dir/crypttab-umount.service"
echo "WantedBy=sysinit.target" >> "$output_dir/crypttab-umount.service"

mkdir -p "$output_dir/sysinit.target.wants"
ln -s "$output_dir/crypttab-umount.service" "$output_dir/sysinit.target.wants/crypttab-umount.service"
