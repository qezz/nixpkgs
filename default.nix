let
  inherit
    (builtins)
    currentSystem
    fromJSON
    readFile
    ;

  getFlake = name:
    with (fromJSON (readFile ./flake.lock)).nodes.${name}.locked; {
      inherit rev;
      outPath = fetchTarball {
        url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
        sha256 = narHash;
      };
    };
in
  {
    system ? currentSystem,
    pkgs ? import (getFlake "nixpkgs") {localSystem = {inherit system;};},
  }:
  # let
  #   wasmvm = "";
  # in
    {} // import ./pkgs {inherit pkgs;}
