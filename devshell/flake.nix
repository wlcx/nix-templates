{
  description = "A basic flake from samw";
  inputs = {
    utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };
  outputs = { self, nixpkgs, utils, devshell }:
    utils.lib.eachDefaultSystem (system: {
      devShells.default = let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ devshell.overlay ];
        };
      in pkgs.devshell.mkShell { packages = with pkgs; [ ]; };
    });
}
