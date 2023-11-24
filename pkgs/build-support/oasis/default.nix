{ lib }: rec {

  build = { autoPatchelfHook, buildGoModule, pkg-config, libseccomp, srcRepo
    , commit ? null, vendorHash ? lib.fakeHash, version, meta }:
    let
      xmeta = meta;

      def = rec {
        pname = "oasis";
        binary = "oasis-node";

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

        inherit version vendorHash;

        doCheck = false;

        disableGoWorkspace = false;
        # Some repos fail to build with Go Workspaces being enabled.
        # And also sometimes I just don't like when someone's telling me to go work.
        GOWORK = if disableGoWorkspace then "off" else null;

        # We don't check the tmpdir in the first stage because it usually
        # needs to build some shared libraries. We get these shared
        # libraries from the output of the first stage.
        # The missing libraries should be caught by autoPatchelf.
        noAuditTmpdir = true;

        proxyVendor = true;

        nativeBuildInputs = [ pkg-config ];
        buildInputs = [ libseccomp ];

        meta = with lib; {
          description = xmeta.name;
          homepage = "https://github.com/${srcRepo}.git";
          mainProgram = binary;
        };

        preBuild = ''
          cd go/oasis-node
        '';
      };

      base = buildGoModule def;
    in base;
}
