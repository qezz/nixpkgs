{ stdenv, buildGoModule, autoPatchelfHook, lib, gcc, git, }:

let
  srcUser = "CosmWasm";
  srcRepo = "wasmvm";
  tag = "v1.2.3";

in buildGoModule rec {
  pname = "wasmvm";
  version = "${tag}";

  src = fetchGit {
    url = "https://github.com/${srcUser}/${srcRepo}.git";
    ref = "refs/tags/${version}";
    rev = "61e41ae2a80081224f469614a267b0ba2a2d305f";
  };

  vendorSha256 = "sha256-cVJMgzS4ZXfW5uM8iG6VmDgt8xfTczt2sJ63G9oeJXc=";

  buildInputs = [
    gcc
    git # libwasmvm
  ];

  # subPackages = [ "cmd/${binary}" ];

  doCheck = false;
  noAuditTmpdir = true;

  #   postInstall = ''
  # patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${lib.makeLibraryPath [ stdenv.cc.cc ]} $out/bin/${binary}
  # '';

  # nativeBuildInputs = [ autoPatchelfHook ];

  # postInstall = ''
  #   echo "=== ${out}"
  # '';

  meta = with lib; {
    description = "Sei Chain";
    homepage = "https://github.com/sei-protocol/sei-chain.git";
    mainProgram = "seid";
  };
}

