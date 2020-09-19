self: super:

let
  callPackage = super.lib.callPackageWith (self);
in {
  ubootEspressobin = callPackage ./u-boot.nix {};
  ubootEspressoImages = callPackage ./images.nix {};
}
