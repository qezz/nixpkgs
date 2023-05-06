{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let
  packages = rec {
    sei-chain = callPackage ./pkgs/sei-chain { };

    inherit pkgs;
  };
in packages
