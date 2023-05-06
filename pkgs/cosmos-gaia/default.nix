{ stdenv, pkgs }:

pkgs.buildGoModule rec {
  pname = "cosmos-gaia";
  version = "9.0.3";

  src = fetchGit {
    url = "https://github.com/cosmos/gaia";
    ref = "refs/tags/v${version}";
    rev = "05b6b87d3c9121e933eab437772ea56f33ae268f";
  };

  vendorSha256 = "sha256-26KNJ58VKh0vOKoq6Xxt5xl7JrlWtLDR6l76lwFobEA=";

  buildInputs = [ pkgs.gcc pkgs.git ];

  subPackages = [ "cmd/gaiad" ];

  doCheck = false;
}
