# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

## My board
I have an V7 1GB board.

It boots with the stock `espressobin-bootloader-cpu-1000-ddr4-1cs-1g-atf-g39a62a1-uboot-g255b9cc-20181107-REL.bin`

## U-boot
Build with `nix-build release.nix -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

### Notes
The Armbian project has [built U-Boot 18.03 images](https://dl.armbian.com/espressobin/u-boot/), but they don't seem to be set up for distro boot config.

### Links
- Armbian forums on A3xx devices, including the ESPRESSObin: https://forum.armbian.com/forum/32-armada-a388-a3700/

## TODO
- Disable topaz switch on boot, so it doesn't forward packets before Linux starts: https://espressobin.net/forums/topic/wan-leaks-into-lan-before-boot-complete-on-openwrt/#post-1330
