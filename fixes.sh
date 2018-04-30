#!/bin/bash
# vim:sts=2:sw=2

# Wireless
function wireless() {
  wget http://jwrdegoede.danny.cz/brcm-firmware/brcmfmac43430-sdio.txt.ap6210.intel -O /lib/firmware/brcm/brcmfmac43430-sdio.txt
  modprobe -r brcmfmac
  modprobe brcmfmac
}

# Audio
function audio() {
  sed -i -e 's/^#load-module module-alsa-source device=/load-module module-alsa-source device=hw:1,0/' /etc/pulse/default.pa
}

$@
