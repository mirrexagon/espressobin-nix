# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

# U-Boot
Build with `nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

The bootloader image produced by this repo is currently only for ESPRESSObin V7 1GB!

### Links
- Issue for mainline U-Boot on the ESPRESSObin: https://github.com/openwrt/openwrt/pull/3360
- Fix for switch initial configuration included in the above: https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/issues/18#issuecomment-685121874
- How to recover from a bad flash: https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/blob/u-boot-2017.03-armada-17.06/doc/mvebu/uart_boot.txt

## Hardware notes
- The V7 schematics (page 9) imply you can boot U-Boot from SD card by setting the three mode jumpers to 1. The [wiki page](http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces) table seems to be wrong, all modes except SPI NOR flash are the same.
