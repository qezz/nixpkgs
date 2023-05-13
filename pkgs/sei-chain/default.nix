{ stdenv, buildGo119Module, makeWrapper, autoPatchelfHook, lib, gcc, git }:

let
  srcRepo = "sei-protocol/sei-chain";
  commit = "d6a3e606c7d3159e489d3499989f571cceca5fb6";
  sdkRepo = "cosmos/cosmos-sdk";
  chain = "sei";
  binary = "${chain}d";
  vendorSha256 = "sha256-x9VlCVors9GYofw3W0Am/TfcE53ZZCfD4d/DPAgZzH8=";
  version = "2.0.48beta";
  meta = { name = "Sei Chain"; };
  buildGoModule = buildGo119Module;
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
      "-X 'github.com/${sdkRepo}/version.BuildTags=netgo ledger,'"
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

