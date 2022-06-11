{
  description = "Another cool golang abhorration from samw";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell = {
    url = "github:numtide/devshell";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay ];
        };
      in rec {
        packages.default = pkgs.buildGoModule {
          name = "my-project";
          src = self;
          vendorSha256 = "";

          # Inject the git version if you want
          #ldflags = ''
          #  -X main.version=${if self ? rev then self.rev else "dirty"}
          #'';
        };

        apps.default = utils.lib.mkApp { drv = packages.default; };

        devShell =
          pkgs.devshell.mkShell { packages = with pkgs; [ go gopls ]; };
      });
}
