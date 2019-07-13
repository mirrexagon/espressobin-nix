#!/usr/bin/env bash

# Cross-compile a derivation from a Nix file.

nix-build -E "with import <nixpkgs> { crossSystem = { config = \"aarch64-unknown-linux-gnu\"; }; }; callPackage $1 {}"
