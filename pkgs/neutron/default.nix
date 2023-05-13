{ stdenv, buildGo120Module, makeWrapper, autoPatchelfHook, lib, gcc, git }:

let
  name = "neutron";
  srcRepo = "neutron-org/neutron";
  version = "v1.0.1";
  commit = "c236f1045f866c341ec26f5c409c04d201a19cde";
  vendorSha256 = "sha256-mFv9VgCAdIyHuZhdsjQbjfQacQbfIhbWhmVNP8+EjKA=";
  sdkRepo = "cosmos/cosmos-sdk";
  chain = "neutron";
  binary = "${chain}d";
  meta = { name = "Neutron Consumer Chain"; };
  buildGoModule = buildGo120Module;
in let
  def = rec {
    pname = name;

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

