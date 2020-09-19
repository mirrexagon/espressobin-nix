self: super:

let
  callPackage = super.lib.callPackageWith (self);
in {
  ubootEspressobin = callPackage ./u-boot.nix {};
  ubootEspressobinImages = callPackage ./images.nix {};
}
