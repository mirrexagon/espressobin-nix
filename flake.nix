{
  description = "ESPRESSObin U-Boot builder";

  inputs = {
    # Commit before 8.2.0 -> 8.4.0 update
    # which was eefdd0983997458528f78445d04066b6d3fc147d
    nixpkgs.url = "github:nixos/nixpkgs?ref=88033a4862c1eb55929b8a4163da2137f377e6af";
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
