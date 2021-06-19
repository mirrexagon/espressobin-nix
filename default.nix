let
  nixpkgs = import <nixpkgs> {};

  oldCryptoppNixpkgs = nixpkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";

    # Commit before 8.2.0 -> 8.4.0 update
    # which was eefdd0983997458528f78445d04066b6d3fc147d
    rev = "88033a4862c1eb55929b8a4163da2137f377e6af";
    sha256 = "sha256-oDCoBorS9MYcZmDO1R2qaAUYbyUtQtTGxBOgTlEDQ9E=";
  };
in import oldCryptoppNixpkgs { overlays = [ (import ./overlay.nix) ]; }
