{ lib }: {
  buildWithPebble = { autoPatchelfHook, buildGoModule, srcRepo, commit ? null
    , sdkRepo ? "cosmos/cosmos-sdk", chain, binary ? "${chain}d", version, meta
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
        inherit src version;

        pname = "${chain}-cosmos3";

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

        # tags = [ "pebbledb" ];

        # ldflags = [
        #   "-X github.com/${sdkRepo}/version.Name=${chain}"
        #   "-X github.com/${sdkRepo}/version.ServerName=${chain}d"
        #   "-X github.com/${sdkRepo}/version.Version=${version}"
        #   # "-X github.com/cosmos/cosmos-sdk/types.DBBackend=pebbledb"
        #   # "-X 'github.com/${sdkRepo}/version.BuildTags=netgo ledger,'"
        # ] ++ (if !(commit == null) then
        #   [ "-X github.com/${sdkRepo}/version.Commit=${src.rev}" ]
        # else
        #   [ ]);

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

        # preBuild = ''
        # renameImports = ''
        #   go mod tidy
        #   # go mod edit -require=github.com/ChorusOne/tm-db@v0.1.8-pebbledb
        #   go mod edit -replace=github.com/tendermint/tm-db=github.com/ChorusOne/tm-db@v0.1.8-pebbledb
        #   # go mod tidy
        # '';

        # overrideModAttrs = (old: {
        preBuild = ''
          echo %%% pre build
          echo %%%
          echo %%%
          go mod download
          go mod edit -replace=github.com/tendermint/tm-db=github.com/ChorusOne/tm-db@v0.1.8-pebbledb
          go mod tidy
          go mod download
          echo %%%
          echo %%%
        '';

        postBuild = ''
          echo %%%
          echo %%% post build
          echo %%%
          echo %%% this goModules: ${goModules}
          echo %%%
          echo %%%
        '';

        proxyVendor = true;

        # vendorHash = "sha256-LrDi/rwLUUSjUTPUFokXe6pb3rBTHL2So1Eo0m64I00=";
        # vendorHash = lib.fakeHash;
        # vendorHash = "sha256-h8dKgsXZQ57qare6UhSjFXekHu9fE4S1245z41yQJt8=";
        # vendorHash = "sha256-3gebktncaqYQ2yHunB1Br7PhvGzodYRo2aaRxZGslAY=";
        vendorHash = "sha256-B+L8gITX89odCCoVmfSlF/zudBcZf3HvRimsBoy5PQg=";
      };

      base = buildGoModule def;
      goModules = base.goModules;

      patched = (def // rec {
        nativeBuildInputs = [
          # autoPatchelfHook
        ];

        # vendorHash = "sha256-3gebktncaqYQ2yHunB1Br7PhvGzodYRo2aaRxZGslAY=";
        # vendorHash = lib.fakeHash;
        # proxyVendor = true;

        preBuild = ''
          echo %%%
          echo %%%
          echo %%% ${./.}
          echo %%% ${base}
          echo %%% base.goModules: ${base.goModules}
          echo %%% this goModules: ${goModules}
          echo %%%
          echo %%% patched pre build
          echo %%%
          echo %%%
          echo %%%

          # go mod edit -replace=github.com/tendermint/tm-db=github.com/ChorusOne/tm-db@v0.1.8-pebbledb
          # go mod tidy

          # addAutoPatchelfSearchPath ${base.goModules}/
        '';

        postBuild = ''
          echo %%%
          echo %%% post build
          echo %%%
          echo %%% this goModules: ${goModules}
          echo %%%
          echo %%%
        '';
      });

    in buildGoModule patched;

}
