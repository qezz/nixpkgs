{ stdenv, buildGoModule, gcc, git, llvmPackages }:

let
  srcUser = "cosmos";
  srcRepo = "gaia";
  sdkRepo = "cosmos-sdk";
  chain = "gaia";
in
buildGoModule rec {
  pname = "cosmos-gaia";
  version = "v9.0.3";

  src = fetchGit {
    url = "https://github.com/${srcUser}/${srcRepo}";
    ref = "refs/tags/${version}";
    rev = "05b6b87d3c9121e933eab437772ea56f33ae268f";
  };

  vendorSha256 = "sha256-26KNJ58VKh0vOKoq6Xxt5xl7JrlWtLDR6l76lwFobEA=";

  buildInputs = [ gcc git ];

  subPackages = [ "cmd/gaiad" ];

  ldflags = [
    "-X github.com/cosmos/${sdkRepo}/version.Name=${chain}"
    "-X github.com/cosmos/${sdkRepo}/version.ServerName=${chain}d"
    "-X github.com/cosmos/${sdkRepo}/version.Version=${version}"
    "-X github.com/cosmos/${sdkRepo}/version.Commit=${src.rev}"
    "-X 'github.com/cosmos/${sdkRepo}/version.BuildTags=netgo ledger,'"
  ];


  doCheck = false;
}
