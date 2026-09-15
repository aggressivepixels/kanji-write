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
      in
      {
        packages = {
          kanji-write = pkgs.runCommand "kanji-write" { } ''
            cp -r ${./src}/. $out
          '';
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
