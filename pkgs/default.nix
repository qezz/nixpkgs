{
  pkgs,
}: let
  callPackage = pkg: pkgs.callPackage pkg;
in {
  cosmos-gaia = callPackage ./cosmos-gaia {};
  cosmwasm-wasmvm = callPackage ./cosmwasm-wasmvm {};
  neutron = callPackage ./neutron {};
  osmosis = callPackage ./osmosis {};
  sei-chain = callPackage ./sei-chain {};
}
