This is a workaround for systemd issue #1620.

Script from this workaround will analyze /etc/crypttab file at system shutdown,
and unmount/deactivate all non-root volumes described there, before systemd attempts to do so.
This should help if you are using older systemd and issue #1620 is not fixed in your distro.

WARNING! this is an experimental workaround, use at your own risk!
