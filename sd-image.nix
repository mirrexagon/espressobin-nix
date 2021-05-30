# ESPRESSObin SD card image.
# Build with: nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./sd-image.nix

{ config, lib, pkgs, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "console=ttyMV0,115200n8"
  ];
}

