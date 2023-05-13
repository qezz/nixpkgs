{ stdenv, buildGoModule, makeWrapper, autoPatchelfHook, lib, gcc, git }:

let
  srcRepo = "osmosis-labs/osmosis";
  commit = "2baf3afd80b1ddf014a0da611e9ee05625c0ec94";
  sdkRepo = "cosmos/cosmos-sdk";
  chain = "osmosis";
  binary = "${chain}d";
  vendorSha256 = "sha256-yiCh0RugRFIrSH25CsdSjUGWh7WswKZcyCxY2PwPOzM=";
  version = "v15.1.0";
  meta = { name = "Osmosis"; };
  # buildGoModule = buildGo119Module;
in let
  def = rec {
    pname = "sei-chain";

    src = fetchGit {
      url = "https://github.com/${srcRepo}.git";
      ref = "refs/tags/${version}";
      rev = "${commit}";
    };

    inherit version vendorSha256;

    subPackages = [ "cmd/${binary}" ];

    doCheck = false;
    GOWORK = "off"; # disable go workspace mod

    # We don't check the tmpdir in the first stage because it usually
    # needs to build some shared libraries. We get these shared
    # libraries from the output of the first stage.
    # The missing libraries should be caught by autoPatchelf.
    noAuditTmpdir = true;

    ldflags = [
      "-X github.com/${sdkRepo}/version.Name=${chain}"
      "-X github.com/${sdkRepo}/version.ServerName=${chain}d"
      "-X github.com/${sdkRepo}/version.Version=${version}"
      "-X github.com/${sdkRepo}/version.Commit=${src.rev}"
      # "-X 'github.com/${sdkRepo}/version.BuildTags=netgo ledger,'"
    ];

    meta = with lib; {
      description = meta.name;
      homepage = "https://github.com/${srcRepo}.git";
      mainProgram = binary;
    };
  };

  base = buildGoModule def;

  patched = (def // {
    nativeBuildInputs = [ autoPatchelfHook ];

    preBuild = ''
      addAutoPatchelfSearchPath ${base.go-modules}/
    '';
  });

in buildGoModule patched

