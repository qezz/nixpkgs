{ stdenv, buildGoModule, makeWrapper, autoPatchelfHook, lib, gcc, git }:

let
  srcUser = "sei-protocol";
  srcRepo = "sei-chain";
  sdkRepo = "cosmos/cosmos-sdk";
  chain = "seid";
  binary = chain;

in let
  def = rec {
    pname = "sei-chain";
    version = "2.0.47beta";

    src = fetchGit {
      url = "https://github.com/${srcUser}/${srcRepo}.git";
      ref = "refs/tags/${version}";
      rev = "b3f7928d359e0f81f19cd6b1a45a655db7ee98b8";
    };

    vendorSha256 = "sha256-nhKz1nI5+0wdvwDloewcWvLNTc8HcloQPsN0ZOuPp2A=";

    buildInputs = [ gcc git ];

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
  };

  meta = with lib; {
    description = "Sei Chain";
    homepage = "https://github.com/sei-protocol/sei-chain.git";
    mainProgram = "seid";
  };

  base = buildGoModule def;

  wrapped = (def // {
    nativeBuildInputs = [ makeWrapper ];
    postInstall = ''
      wrapProgram $out/bin/${binary} \
        --prefix LD_LIBRARY_PATH : ${base.go-modules}/github.com/CosmWasm/wasmvm/internal/api
    '';
  });

in buildGoModule wrapped

