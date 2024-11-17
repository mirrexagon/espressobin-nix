{
  description = "ESPRESSObin U-Boot builder";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "aarch64-linux";
      pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
    in
    {
      overlays.default = import ./overlay.nix;

      packages."${system}" = {
        inherit (pkgs)
          ubootEspressobin
          ubootEspressobinImages_512MB
          ubootEspressobinImages_V5_1GB_2CS
          ubootEspressobinImages_V5_1GB_1CS
          ubootEspressobinImages_V7_1GB
          ubootEspressobinImages_V7_2GB
          ubootEspressobinImages_V5_2GB;
      };
    };
}
