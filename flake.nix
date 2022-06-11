{
  description = "Samw's Nix flake templates";
  inputs = { utils.url = "github:numtide/flake-utils"; };

  outputs = { self, utils, nixpkgs }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "My preferred rust setup.";
        };
        go = {
          path = ./go;
          description = "My preferred go setup.";
        };
        devshell = {
          path = ./devshell;
          description = "A basic devshell setup";
        };
      };
    } // utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in { formatter = pkgs.nixfmt; });
}
