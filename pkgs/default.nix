{ pkgs }:
let callPackage = pkg: pkgs.callPackage pkg;
in rec {
  cosmos = callPackage ./cosmos { };

  cosmwasm-wasmvm = callPackage ./cosmwasm-wasmvm { };
  oasis = callPackage ./build-support/oasis { };

  cosmos-gaia = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "cosmos/gaia";
      chain = "gaia";
      version = "v12.0.0";
      meta = { name = "Cosmos Hub a.k.a Gaia"; };
      vendorSha256 = "sha256-6MDvoxuSMLvwguh/4PdS9K5Mdlr8c1fZDzP5asDYPDk=";
    };

  evmos = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "tharsis/evmos";
      chain = "evmos";
      version = "v14.1.0";
      meta = { name = "Evmos Chain"; };
      vendorSha256 = "sha256-ftZh8uSQX5I2du96e2MnocbYHgtE5M0KD75jV6siJRo=";
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

  kava = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "kava-labs/kava";
      chain = "kava";
      binary = "kava";
      version = "v0.24.0";
      meta = { name = "Kava"; };
      vendorSha256 = "sha256-emfj6KUwCDRACGASyyoKPthBF88jhUKHAGpGqzRpYq8=";

      disableGoWorkspace = true;
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

  neutron = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "neutron-org/neutron";
      chain = "neutron";
      version = "v1.0.4";
      meta = { name = "Neutron Consumer Chain"; };
      vendorSha256 = "sha256-jlzFYx09U7BkBg9LDZqfwT4aASQSbuVBl0a/WCrly8A=";
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

  persistence = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "persistenceOne/persistenceCore";
      chain = "persistence";
      binary = "persistenceCore";
      version = "v9.2.1";
      meta = { name = "Persistence Chain"; };
      vendorSha256 = "sha256-uMFdzS1ldf7tRajR1kHZHJOA0n/mmySoFVxd3PSiQHE=";
    };

  sei-chain = with pkgs;
    cosmos.build {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "sei-protocol/sei-chain";
      chain = "sei";
      version = "v3.3.0";
      meta = { name = "Sei Chain"; };
      vendorSha256 = "sha256-LrDi/rwLUUSjUTPUFokXe6pb3rBTHL2So1Eo0m64I00=";
    };

  sei-pebble = with pkgs;
    cosmos.buildWithPebble {
      inherit autoPatchelfHook buildGoModule;

      srcRepo = "sei-protocol/sei-chain";
      chain = "sei";
      version = "v3.3.0";
      meta = { name = "Sei Chain"; };
      vendorHash1 = "sha256-LrDi/rwLUUSjUTPUFokXe6pb3rBTHL2So1Eo0m64I00=";
      vendorHash2 = "sha256-3gebktncaqYQ2yHunB1Br7PhvGzodYRo2aaRxZGslAY=";
    };

  oasis-node = with pkgs;
    oasis.build {
      inherit autoPatchelfHook pkg-config libseccomp;

      buildGoModule = pkgs.buildGo121Module;
      srcRepo = "oasisprotocol/oasis-core";
      version = "v23.0.5";
      meta = { name = "Oasis Node"; };
      vendorHash = "sha256-3vXoqSgkG7YKO9C0FQuurRlI6KwH1COZdoKp8cDUMn0=";
    };
}
