{ lib }: rec {

  build = { autoPatchelfHook, buildGoModule, srcRepo, commit ? null
    , sdkRepo ? "cosmos/cosmos-sdk", chain, binary ? "${chain}d"
    , vendorSha256 ? lib.fakeSha256, version, meta, disableGoWorkspace ? false
    }:
    let
      def = rec {
        pname = "${chain}";

        src = (if !(commit == null) then
          fetchGit {
            url = "https://github.com/${srcRepo}.git";
            ref = "refs/tags/${version}";
            rev = commit;
          }
        else
          fetchGit {
            url = "https://github.com/${srcRepo}.git";
            ref = "refs/tags/${version}";
          });

        inherit version vendorSha256;

        subPackages = [ "cmd/${binary}" ];

        doCheck = false;

        # Some repos fail to build with Go Workspaces being enabled.
        # And also sometimes I just don't like when someone's telling me to go work.
        GOWORK = if disableGoWorkspace then "off" else null;

        # We don't check the tmpdir in the first stage because it usually
        # needs to build some shared libraries. We get these shared
        # libraries from the output of the first stage.
        # The missing libraries should be caught by autoPatchelf.
        noAuditTmpdir = true;

        ldflags = [
          "-X github.com/${sdkRepo}/version.Name=${chain}"
          "-X github.com/${sdkRepo}/version.ServerName=${chain}d"
          "-X github.com/${sdkRepo}/version.Version=${version}"
          # "-X 'github.com/${sdkRepo}/version.BuildTags=netgo ledger,'"
        ] ++ (if !(commit == null) then
          [ "-X github.com/${sdkRepo}/version.Commit=${src.rev}" ]
        else
          [ ]);

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
          addAutoPatchelfSearchPath ${base.goModules}/
        '';
      });

    in buildGoModule patched;

  buildWithPebble = { autoPatchelfHook, buildGoModule, srcRepo, commit ? null
    , sdkRepo ? "cosmos/cosmos-sdk", chain, binary ? "${chain}d"
    , vendorHash1 ? lib.fakeHash, vendorHash2 ? lib.fakeHash, version, meta
    , disableGoWorkspace ? false }:
    let
      url = "https://github.com/${srcRepo}.git";
      ref = "refs/tags/${version}";
      src = (if !(commit == null) then
        fetchGit {
          inherit url ref;
          rev = commit;
        }
      else
        fetchGit { inherit url ref; });

      def = rec {
        inherit src version; # vendorSha256;

        pname = "${chain}-3";

        subPackages = [ "cmd/${binary}" ];

        doCheck = false;

        # Some repos fail to build with Go Workspaces being enabled.
        # And also sometimes I just don't like when someone's telling me to go work.
        GOWORK = if disableGoWorkspace then "off" else null;

        # We don't check the tmpdir in the first stage because it usually
        # needs to build some shared libraries. We get these shared
        # libraries from the output of the first stage.
        # The missing libraries should be caught by autoPatchelf.
        noAuditTmpdir = true;

        ldflags = [
          "-X github.com/${sdkRepo}/version.Name=${chain}"
          "-X github.com/${sdkRepo}/version.ServerName=${chain}d"
          "-X github.com/${sdkRepo}/version.Version=${version}"
          # "-X 'github.com/${sdkRepo}/version.BuildTags=netgo ledger,'"
        ] ++ (if !(commit == null) then
          [ "-X github.com/${sdkRepo}/version.Commit=${src.rev}" ]
        else
          [ ]);

        meta = with lib; {
          description = meta.name;
          homepage = "https://github.com/${srcRepo}.git";
          mainProgram = binary;
        };

        vendorHash = vendorHash1;
      };

      base = buildGoModule def;
      goModules = base.goModules;

      patched = (def // rec {
        nativeBuildInputs = [ autoPatchelfHook ];

        vendorHash = vendorHash2;
        proxyVendor = true;

        tags = [ "pebbledb" ];

        preBuild = ''
          go mod edit -replace=github.com/tendermint/tm-db=github.com/ChorusOne/tm-db@v0.1.8-pebbledb
          go mod tidy

          addAutoPatchelfSearchPath ${base.goModules}/
        '';
      });

    in buildGoModule patched;

}
