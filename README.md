# NixOS on the Marvell ESPRESSObin
http://espressobin.net/


## Bootloader
Different versions of the ESPRESSObin board have different memory layouts, which require different builds of the bootloader.

Note which one of these applies to your board, and replace `<configuration>` in the instructions below with the appropriate one.
- `512MB`
- `V5_1GB_2CS`
- `V5_1GB_1CS`
- `V7_1GB`
- `V7_2GB`
- `V5_2GB`

### Cross-compiling via `default.nix`
Clone the repository and run `nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages_<configuration>`

Note that this uses your system nixpkgs, which may not be compatible. The flake build guarantees using a known working revision of nixpkgs.

eg. To build for the V7 1GB board, run `nix-build -A pkgsCross.aarch64-multiplatform.ubootEspressobinImages_V7_1GB`

### Building via the flake
NOTE: Flake builds don't support cross-compilation. I build it on my `x86_64-linux` NixOS machines by enabling AArch64 binfmt emulation, but that is very slow compared to cross-compilation. See https://wiki.nixos.org/wiki/NixOS_on_ARM/Building_Images#Compiling_through_binfmt_QEMU

Build the bootloader without needing to clone the repository with `nix build --experimental-features 'nix-command flakes' github:mirrexagon/espressobin-nix#packages.aarch64-linux.ubootEspressobinImages_<configuration>`

eg. To build for the V7 1GB board, run `nix build --experimental-features 'nix-command flakes' github:mirrexagon/espressobin-nix#packages.aarch64-linux.ubootEspressobinImages_V7_1GB`

### Flashing from U-Boot (original or from this repo)
Adapted from the USB stick instructions from http://wiki.espressobin.net/tiki-index.php?page=Update+the+Bootloader

1. Copy `result/flash-image.bin` to a USB stick.
1. Connect a USB cable to the serial port on the ESPRESSObin and boot it with the current bootloader.
1. Press enter to stop autoboot and get to the shell.
1. Run `bubt flash-image.bin spi usb`
1. Run `reset` to reset the board and boot into the new bootloader.

### Extra steps after flashing
Stop autoboot, load the default U-Boot environment with `env default -a`, save it with `env save`, then `reset`.

The main goal is to get the `fdtfile` U-Boot variable to be automatically set correctly. To see the current value, run `echo $fdtfile`.

- On an ESPRESSObin V5, the correct value is `marvell/armada-3720-espressobin.dtb`.
- On an ESPRESSObin V7, the correct value is `marvell/armada-3720-espressobin-v7.dtb`.

### Recovering from a bad flash
- Make sure you have built the appropriate U-Boot images for your board - the `result` symlink in the repo top level should point to them.
- Set the boot jumpers on the board to boot into UART mode: http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces#Boot_selection
- Connect the USB serial port, ensure it comes up as `/dev/ttyUSB0`, then run `./uart-recover.sh`, where `<configuration>` is as in the U-Boot section.
- Set the boot jumpers back to booting from the SPI NOR flash and reset the board (press the reset button or unplug and plug in the power).

## SD image
The default AArch64 NixOS image will boot unmodified on the ESPRESSObin.

This should already work as it is set in the device tree, but if you don't get serial output over USB in Linux, `console=ttyMV0,115200n8` needs to be added to the kernel command line.

## NixOS configuration

### MAC addresses
If not set in the U-Boot environment, MAC addresses are randomized on boot. To set these up so that U-Boot sets them and passes them to Linux, boot to the U-Boot console and set these variables in the environment (using the MAC addresses printed on my device as an example, adjust them to what yours has if you can):

- `env set ethaddr f0:ad:4e:09:08:a0` for the switch-SoC connection `end0`
- `env set eth1addr f0:ad:4e:09:08:a1` for `wan`
- `env set eth2addr f0:ad:4e:09:08:a2` for `lan0`
- `env set eth3addr f0:ad:4e:09:08:a3` for `lan1`
- `env save`

A secondary option is setting in NixOS configuration instead. This is slightly less desirable as the MAC addresses in the U-Boot environment (eg. for network boot) will still be randomized.

```nix
networking.interfaces.end0.macAddress = "f0:ad:4e:09:08:a0";
networking.interfaces.wan.macAddress = "f0:ad:4e:09:08:a1";
networking.interfaces.lan0.macAddress = "f0:ad:4e:09:08:a2";
networking.interfaces.lan1.macAddress = "f0:ad:4e:09:08:a3";
```

### DHCP and `eth0`/`end0`
On at least Linux 6.6.60, networking should work correctly with a default setup.

See these links for more information and discussion on potential configuration issues with the ESPRESSObin ethernet hardware:

- https://github.com/mirrexagon/espressobin-nix/issues/2
- https://github.com/systemd/systemd/issues/7478

## Hardware notes
- The V7 schematics (page 9) imply you can boot U-Boot from SD card by setting the three mode jumpers to 1. The [wiki page](http://wiki.espressobin.net/tiki-index.php?page=Ports+and+Interfaces) table seems to be wrong, all modes except SPI NOR flash are the same.
