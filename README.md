# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

This does NOT currently work. I'm working on getting the built bootloader to boot correctly.

## My board
I have an V7 1GB board.

It boots with the stock `espressobin-bootloader-cpu-1000-ddr4-1cs-1g-atf-g39a62a1-uboot-g255b9cc-20181107-REL.bin`

## U-Boot
Build with `nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

### Links
- Issue for mainline U-Boot on the ESPRESSObin: https://github.com/openwrt/openwrt/pull/3360
- Fix for switch initial configuration included in the above: https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/issues/18#issuecomment-685121874

## Hardware notes
- The V7 schematics (page 9) imply you can boot U-Boot from SD card by setting the three mode jumpers to 1. The [wiki page](http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces) table seems to be wrong, all modes except SPI NOR flash are the same.
