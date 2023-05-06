{ stdenv, pkgs }:

pkgs.buildGoModule rec {
  pname = "sei-chain";
  version = "2.0.47beta";

  src = fetchGit {
    url = "https://github.com/sei-protocol/sei-chain.git";
    ref = "refs/tags/${version}";
    rev = "b3f7928d359e0f81f19cd6b1a45a655db7ee98b8";
  };

  vendorSha256 = "sha256-nhKz1nI5+0wdvwDloewcWvLNTc8HcloQPsN0ZOuPp2A=";

  buildInputs = [ pkgs.gcc pkgs.git ];

  subPackages = [ "cmd/seid" ];

  ldflags = [ "-s" "-w" ];
 # buildPhase = ''
 #    runHook preBuild
 #    make build
 #    runHook postBuild
 #  '';

  doCheck = false;
}
