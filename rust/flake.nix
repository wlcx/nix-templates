{
  description = "Another cool rust disaster from samw.";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    naersk.url = "github:nix-community/naersk";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, utils, naersk, devshell, rust-overlay }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        rust = rust-bin.stable.latest.default;
        naersk-lib = naersk.lib.${system}.override {
          cargo = rust;
          rust = rust;
        };
      in {
        defaultPackage = naersk-lib.buildPackage ./.;

        defaultApp = utils.lib.mkApp { drv = self.defaultPackage."${system}"; };

        # Provide a dev env with rust and rls
        devShell = let
          pkgs = import nixpkgs {
            inherit system;

            overlays = [ devshell.overlay (import rust-overlay) ];
          };
        in pkgs.devshell.mkShell {
          packages = with pkgs; [ (rust.override { extensions = [ "rls" ]; }) ];
        };
      });
}
