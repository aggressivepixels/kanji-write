{
  description = "KanjiWrite Anki plugin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        version = self.rev or self.lastModifiedDate;
        src = pkgs.runCommand "kanji-write-src" { } ''
          cp -r ${./src}/. $out
        '';

        # Type stubs for PyQt6, used by the LSP. Anki bundles PyQt6 without
        # any stubs, so its `aqt.qt` re-exports can't be resolved otherwise.
        pyqt6-stubs = pkgs.python3.pkgs.buildPythonPackage {
          pname = "PyQt6-stubs";
          version = "20250824";
          format = "wheel";
          src = pkgs.fetchurl {
            url = "https://files.pythonhosted.org/packages/54/57/08d3a5c19f2d2fd773d2329d19692e682ab9e2a6620c1a586a744d50b52b/pyqt6_stubs-20250824-py3-none-any.whl";
            hash = "sha256-S3fcQPXat8pLqJn/9MHbjenMc3me6Y9WyuYzSfGKblI=";
          };
        };

      in
      {
        packages = {
          kanji-write = src;
          kanji-write-anki-addon = pkgs.anki-utils.buildAnkiAddon {
            pname = "kanji-write";
            inherit version src;
          };
        };

        devShells = {
          default = pkgs.mkShell {
            packages = [
              (pkgs.python3.withPackages (_ps: [
                pyqt6-stubs
              ]))
              pkgs.anki
            ];
          };
        };
      }
    );
}
