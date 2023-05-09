{ stdenv, buildGoModule, makeWrapper, autoPatchelfHook, lib, gcc, git }:

let
  chain = "osmosis";
  binary = "${chain}d";
  version = "v15.1.0";
in let
  def = rec {
    pname = "${binary}";
    inherit version;

    src = fetchGit {
      url = "https://github.com/osmosis-labs/osmosis.git";
      ref = "refs/tags/${version}";
      rev = "2baf3afd80b1ddf014a0da611e9ee05625c0ec94";
    };

    vendorSha256 = "sha256-yiCh0RugRFIrSH25CsdSjUGWh7WswKZcyCxY2PwPOzM=";

    buildInputs = [ gcc git ];

    subPackages = [ "cmd/${binary}" ];

    doCheck = false;
    GOWORK = "off"; # disable go workspace mod
    noAuditTmpdir = true;

    sdkRepo = "cosmos-sdk";
    ldflags = [
      "-X github.com/cosmos/${sdkRepo}/version.Name=${chain}"
      "-X github.com/cosmos/${sdkRepo}/version.ServerName=${chain}d"
      "-X github.com/cosmos/${sdkRepo}/version.Version=${version}"
      "-X github.com/cosmos/${sdkRepo}/version.Commit=${src.rev}"
      "-X 'github.com/cosmos/${sdkRepo}/version.BuildTags=netgo ledger,'"
    ];

    meta = with lib; {
      description = "Osmosis";
      homepage = "https://github.com/osmosis-labs/osmosis.git";
      mainProgram = "${binary}";
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
