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
              pkgs.python3
              pkgs.anki
            ];
          };
        };
      }
    );
}
