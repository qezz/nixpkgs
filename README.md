# Nixpkgs

Contains a set of selected packages.

```
$ nix-env --show-trace -f $(pwd) -qaP '*' | cat

cosmos-gaia      gaia-v12.0.0
neutron          neutron-v1.0.4
osmosis          osmosis-v19.2.0
sei-chain        sei-v3.1.1
cosmwasm-wasmvm  wasmvm-v1.2.3
```

## Build

```
$ make <package-name>
```

or

```
$ nix-build --show-trace $(pwd) -A <package-name>
```

## Package

Example definition:

```nix
  osmosis = with pkgs; cosmos.build {
    inherit autoPatchelfHook buildGoModule;

    srcRepo = "osmosis-labs/osmosis";
    chain = "osmosis";
    version = "v19.2.0";
    meta = {
      name = "Osmosis";
    };
    vendorSha256 = "sha256-5r6dXIBzAgegI8U6QwxqB63eKLT8WTZML23EaDif+YE=";
  };
```

If `vendorSha256` is omitted, it will default to `lib.fakeSha256`
