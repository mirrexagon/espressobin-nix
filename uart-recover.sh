#!/usr/bin/env bash
set -euo pipefail

# Reference:
# http://wiki.espressobin.net/tiki-index.php?page=Bootloader+recovery+via+UART
# https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/blob/u-boot-2017.03-armada-17.06/doc/mvebu/uart_boot.txt

# Ensure your board is in UART download mode.
# http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces#Boot_selection
# Ensure the serial port is present as /dev/ttyUSB0.
# Then run this script.

IMAGES_PATH=$(nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages_$1)

$IMAGES_PATH/bin/WtpDownload_linux -P UART -C 0 -R 115200 \
		-B $IMAGES_PATH/uart-images/TIM_ATF.bin -I $IMAGES_PATH/uart-images/boot-image_h.bin \
		-I $IMAGES_PATH/uart-images/wtmi_h.bin -E
