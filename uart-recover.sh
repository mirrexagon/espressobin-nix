#!/usr/bin/env bash

# Ensure your board is in UART download mode.
# http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces#Boot_selection
# Ensure the serial port is present as /dev/ttyUSB0.
# Then run this script.

IMAGES_PATH=$(nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages)

$IMAGES_PATH/bin/WtpDownload_linux -P UART -C 0 -R 115200 \
		-B $IMAGES_PATH/uart-images/TIM_ATF.bin -I $IMAGES_PATH/uart-images/boot-image_h.bin \
		-I $IMAGES_PATH/uart-images/wtmi_h.bin -E
