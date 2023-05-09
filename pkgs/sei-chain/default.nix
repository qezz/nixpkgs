{ stdenv, buildGoModule, makeWrapper, autoPatchelfHook, lib, gcc, git }:

let
  srcRepo = "sei-protocol/sei-chain";
  commit = "b3f7928d359e0f81f19cd6b1a45a655db7ee98b8";
  sdkRepo = "cosmos/cosmos-sdk";
  chain = "sei";
  binary = "${chain}d";
  vendorSha256 = "sha256-nhKz1nI5+0wdvwDloewcWvLNTc8HcloQPsN0ZOuPp2A=";

in let
  def = rec {
    pname = "sei-chain";
    version = "2.0.47beta";

    src = fetchGit {
      url = "https://github.com/${srcRepo}.git";
      ref = "refs/tags/${version}";
      rev = "${commit}";
    };

    inherit vendorSha256;

    subPackages = [ "cmd/${binary}" ];

    doCheck = false;
    noAuditTmpdir = true;

    ldflags = [
      "-X github.com/${sdkRepo}/version.Name=${chain}"
      "-X github.com/${sdkRepo}/version.ServerName=${chain}d"
      "-X github.com/${sdkRepo}/version.Version=${version}"
      "-X github.com/${sdkRepo}/version.Commit=${src.rev}"
      "-X 'github.com/${sdkRepo}/version.BuildTags=netgo ledger,'"
    ];

    meta = with lib; {
      description = "Sei Chain";
      homepage = "https://github.com/sei-protocol/sei-chain.git";
      mainProgram = "seid";
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

