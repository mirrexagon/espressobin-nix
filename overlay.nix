self: super:

let
  callPackage = super.lib.callPackageWith (self);
in {
  ubootEspressobin = callPackage ./u-boot/u-boot.nix {};
  ubootEspressobinImages = callPackage ./u-boot/images.nix {};
}
