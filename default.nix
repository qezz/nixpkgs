{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  packages = rec {
    sei-chain = callPackage ./pkgs/sei-chain { };
    cosmos-gaia = callPackage ./pkgs/cosmos-gaia { };

    inherit pkgs;
  };
in packages
