# ESPRESSObin SD card image.
# Build with: nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=./sd-image.nix

{ ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix>
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "console=ttyMV0,115200n8"
  ];
}

