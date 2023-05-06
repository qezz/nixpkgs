{
  description = "My Nix pkgs repository";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = rec {
        sei-chain = pkgs.callPackage ./pkgs/sei-chain { };
      };
    };
}
