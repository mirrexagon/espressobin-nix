self: super:

let
  callPackage_self = super.lib.callPackageWith (self);
in {
  ubootEspressobin = super.callPackage ./u-boot.nix {};
  a3700UtilsEspressobin = super.callPackage ./a3700-utils.nix {};
  armTrustedFirmwareEspressobin = super.callPackage ./arm-trusted-firmware.nix {};

  ubootEspressobinImages = callPackage_self ./images.nix {};
}
