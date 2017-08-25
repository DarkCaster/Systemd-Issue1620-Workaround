#!/bin/bash
#

timeout="30"

echo_stderr () {
  1>&2 echo "$@"
}

[[ ! -f "/etc/crypttab" ]] && echo "/etc/crypttab file missing..." && exit 0

umount_mp ()
{
  local mp="$1"
  local ec="0"
  echo "trying to umount $mp"
  local timeleft="$timeout"
  while [[ $timeleft != 0 ]]
  do
    2>/dev/null umount -R $mp
    ec="$?"
    [[ $ec = 0 ]] && return
    [[ $ec = 1 ]] && echo_stderr "cannot umount $mp" && return
    if [[ $ec = 32 ]]; then
      echo "failed to umount $mp, retrying in 1 second"
      sleep 1
      (( timeleft -= 1 ))
      continue
    fi
    echo_stderr "umount: error code $ec handling is not implemented"
    return
  done
}

process_mountpoints ()
{
  findmnt -U -n -r "/dev/mapper/$1" | while read -r mnt line_end
  do
    [[ $mnt = "/" ]] && continue
    umount_mp "$mnt"
  done
  return 0
}

while read -r devname line_end
do
  process_mountpoints "$devname"
done < "/etc/crypttab"
