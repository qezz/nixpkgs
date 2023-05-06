{
  pkgs,
}: let
  callPackage = pkg: pkgs.callPackage pkg;
in {
  sei-chain = callPackage ./sei-chain {};
  cosmos-gaia = callPackage ./cosmos-gaia {};
  osmosis = callPackage ./osmosis {};
  cosmwasm-wasmvm = callPackage ./cosmwasm-wasmvm {};
}
