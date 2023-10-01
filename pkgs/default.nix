{ pkgs }:
let callPackage = pkg: pkgs.callPackage pkg;
in rec {
  cosmos = callPackage ./cosmos { };

  cosmwasm-wasmvm = callPackage ./cosmwasm-wasmvm { };

  cosmos-gaia = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "cosmos/gaia";
      chain = "gaia";
      version = "v12.0.0";
      meta = { name = "Cosmos Hub a.k.a Gaia"; };
      vendorSha256 = "sha256-6MDvoxuSMLvwguh/4PdS9K5Mdlr8c1fZDzP5asDYPDk=";
    };

  osmosis = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "osmosis-labs/osmosis";
      chain = "osmosis";
      version = "v19.2.0";
      meta = { name = "Osmosis"; };
      vendorSha256 = "sha256-5r6dXIBzAgegI8U6QwxqB63eKLT8WTZML23EaDif+YE=";

      disableGoWorkspace = true;
    };

  sei-chain = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "sei-protocol/sei-chain";
      chain = "sei";
      version = "v3.1.1";
      meta = { name = "Sei Chain"; };
      vendorSha256 = "sha256-tdkyV7cPWI20Z0nnR+3uKboAY5q/Lkg39VlKUr2l2Pc=";
    };

  neutron = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "neutron-org/neutron";
      chain = "neutron";
      version = "v1.0.4";
      meta = { name = "Neutron Consumer Chain"; };
      vendorSha256 = "sha256-jlzFYx09U7BkBg9LDZqfwT4aASQSbuVBl0a/WCrly8A=";
    };

  mars = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "mars-protocol/hub";
      chain = "mars";
      version = "v1.0.2";
      meta = { name = "Mars Chain"; };
      vendorSha256 = "sha256-tzxK228nBtBHdoVbdsf/3z96F8UymPdmnZExeZzq4PA=";
    };

  juno = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "CosmosContracts/juno";
      chain = "juno";
      version = "v17.0.0";
      meta = { name = "Juno Chain"; };
      vendorSha256 = "sha256-r3osfxZ8jfpUSfBTHrElVTiOr330svQi+E+s/eoxNRE=";
    };
}
