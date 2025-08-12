let
  pkgs = import <nixpkgs> {};
  result =
    pkgs.lib.evalModules {
      modules = [
        ./options.nix
        ./config.nix
        ({ ... }: { config = { a = { ab = 1; }; }; })
      ];
    };
in result.config
