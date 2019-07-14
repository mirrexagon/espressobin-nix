# NixOS on the Marvell ESPRESSObin
http://espressobin.net/

## My board
I have an V7 1GB board.

## U-boot
Hacky way to build: link u-boot as an overlay, then run `nix build -f channel:nixos-unstable pkgsCross.aarch64-multiplatform.ubootEspressobinImages`.

### Links
- Bootloader build instructions: http://wiki.espressobin.net/tiki-index.php?page=Build+From+Source+-+Bootloader
- Forum post about building and flashing U-boot: http://espressobin.net/forums/topic/how-to-flash-u-boot/
- A mailing list thread complaining about how ridiculous the bootloader build process is: https://lists.debian.org/debian-arm/2018/08/msg00014.html
- Implies upstream U-Boot supports Espressobin, maybe they mean Marvell's fork does (and maybe only v5): http://espressobin.net/forums/topic/how-to-flash-u-boot/
- An issue about adding distro config support to Marvell's U-boot fork: https://github.com/MarvellEmbeddedProcessors/u-boot-marvell/issues/3
- A poor single mailing list post about trying to make upstream U-Boot work (mentioned in a comment in the previous link): https://lists.denx.de/pipermail/u-boot/2018-August/339362.html
- Someone trying newer U-boot, includes build command: https://github.com/MarvellEmbeddedProcessors/atf-marvell/issues/12
- Someone's step-by-step build process: https://lists.denx.de/pipermail/u-boot//2017-July/298761.html
