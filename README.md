# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

# U-Boot
Build with `nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

The bootloader image produced by this repo is currently only for ESPRESSObin V7 1GB!

## Extra steps after flashing
1. Load default U-Boot environment with `env default -a`.
1. Set the correct device tree filename in U-Boot with `setenv fdtfile marvell/armada-3720-espressobin.dtb; saveenv`.

## Boot the generic aarch64 image
1. Add `console=ttyMV0,115200n8` to the kernel command line.

## TODO
- Fix fdtfile determination in U-Boot (V7 vs not). I think this is broken by the board/board_name variables being wrong.
- Fix MAC addresses not being passed to Linux.

## Links
- Issue for mainline U-Boot on the ESPRESSObin: https://github.com/openwrt/openwrt/pull/3360
- Fix for switch initial configuration included in the above: https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/issues/18#issuecomment-685121874
- How to recover from a bad flash: https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/blob/u-boot-2017.03-armada-17.06/doc/mvebu/uart_boot.txt
- U-Boot documentation for Marvell SoCs: https://gitlab.denx.de/u-boot/u-boot/blob/master/doc/README.marvell
- ARM trusted firmware documentation for Marvell Armada: https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/plat/marvell/armada/build.rst

## Hardware notes
- The V7 schematics (page 9) imply you can boot U-Boot from SD card by setting the three mode jumpers to 1. The [wiki page](http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces) table seems to be wrong, all modes except SPI NOR flash are the same.
