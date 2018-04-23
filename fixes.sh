#!/bin/bash
# vim:sts=2:sw=2

# Wireless
function wireless() {
  wget http://jwrdegoede.danny.cz/brcm-firmware/brcmfmac43430-sdio.txt.ap6210.intel -O /lib/firmware/brcm/brcmfmac43430-sdio.txt
  modprobe -r brcmfmac
  modprobe brcmfmac
}

$@
