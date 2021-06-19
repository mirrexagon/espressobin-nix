# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

## U-Boot
Build with `nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

The bootloader image produced by this repo is currently only for ESPRESSObin V7 1GB!

The reason for this is that different boards have different memory layouts, and the memory layout is current hardcoded to the V7 1GB board.

### Flashing
Adapted from the USB stick instructions from http://wiki.espressobin.net/tiki-index.php?page=Update+the+Bootloader

1. Copy `result/flash-image.bin` to a USB stick.
1. Connect a USB cable to the serial port on the ESPRESSObin and boot it with the current bootloader.
1. Press enter to stop autoboot and get to the shell.
1. Run `usb start`
1. Run `bubt flash-image.bin spi usb`
1. Run `reset` to reset the board and see if it boots into the newly-flashed U-Boot.

### Extra steps after flashing
1. Load default U-Boot environment with `env default -a`, and save it with `env save`.

### Recovering from a bad flash
See https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/blob/u-boot-2017.03-armada-17.06/doc/mvebu/uart_boot.txt

`WtpDownload_linux` is built as part of `ubootEspressobinImages`.

## SD image
To get serial output over USB in Linux, `console=ttyMV0,115200n8` needs to be added to the kernel command line.

To build an SD card image with this already set, run `nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./sd-image.nix`\
TODO: This probably requires an Aarch64 host, figure out how to cross-compile.

## TODO
- Fix MAC addresses not being passed to Linux.

## Links
- U-Boot documentation for Marvell SoCs: https://gitlab.denx.de/u-boot/u-boot/blob/master/doc/README.marvell
- ARM trusted firmware documentation for Marvell Armada: https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/plat/marvell/armada/build.rst

## Hardware notes
- The V7 schematics (page 9) imply you can boot U-Boot from SD card by setting the three mode jumpers to 1. The [wiki page](http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces) table seems to be wrong, all modes except SPI NOR flash are the same.
