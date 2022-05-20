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
      };
    } // utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in { formatter = pkgs.nixfmt; });
}
