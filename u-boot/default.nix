self: super:

let
  callPackage_self = super.lib.callPackageWith (self);
in {
  ubootEspressobin = super.callPackage ./u-boot.nix {};
  ubootEspressobinImages = callPackage_self ./images.nix {};
}
