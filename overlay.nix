final: prev:

let
  callPackage = prev.lib.callPackageWith final;
in
{
  ubootEspressobin = callPackage ./u-boot/u-boot.nix { };

  ubootEspressobinImages_512MB = callPackage ./u-boot/bootloader-image.nix { boardName = "512MB"; ddrTopology = 0; };
  ubootEspressobinImages_V5_1GB_2CS = callPackage ./u-boot/bootloader-image.nix { boardName = "V5-1GB-2CS"; ddrTopology = 2; };
  ubootEspressobinImages_V5_1GB_1CS = callPackage ./u-boot/bootloader-image.nix { boardName = "V5-1GB-1CS"; ddrTopology = 4; };
  ubootEspressobinImages_V7_1GB = callPackage ./u-boot/bootloader-image.nix { boardName = "V7-1GB"; ddrTopology = 5; };
  ubootEspressobinImages_V7_2GB = callPackage ./u-boot/bootloader-image.nix { boardName = "V7-2GB"; ddrTopology = 6; };
  ubootEspressobinImages_V5_2GB = callPackage ./u-boot/bootloader-image.nix { boardName = "V5-2GB"; ddrTopology = 7; };
}
