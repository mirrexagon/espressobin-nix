# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

This does NOT currently work. I'm working on getting the built bootloader to boot correctly.

## My board
I have an V7 1GB board.

It boots with the stock `espressobin-bootloader-cpu-1000-ddr4-1cs-1g-atf-g39a62a1-uboot-g255b9cc-20181107-REL.bin`

## U-boot
Build with `nix-build release.nix -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

### Notes
The Armbian project has [built U-Boot 18.03 images](https://dl.armbian.com/espressobin/u-boot/), but they don't seem to be set up for distro boot config.

### Links
- Armbian forums on A3xx devices, including the ESPRESSObin: https://forum.armbian.com/forum/32-armada-a388-a3700/
- Useful forum post containing email from Marvell employee about bootloader loading and development: https://forum.armbian.com/topic/4089-espressobin-support-development-efforts/page/4/?tab=comments#comment-36260

## Hardware notes
- The V7 schematics (page 9) imply you can boot U-Boot from SD card by setting the three mode jumpers to 1. The [wiki page](http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces) table seems to be wrong, all modes except SPI NOR flash are the same.

## TODO
- Disable Topaz switch on boot, so it doesn't forward packets before Linux starts: http://espressobin.net/forums/topic/are-lan0-and-lan1-bridged-in-hardware/
