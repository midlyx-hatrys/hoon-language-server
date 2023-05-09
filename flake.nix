{
  description = "LSP bridge for Hoon";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self
    , nixpkgs
    , parts
  }: parts.lib.mkFlake { inherit inputs; } {
    systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

    perSystem = { pkgs, system, ... }: {
      packages.hoon-language-server = pkgs.callPackage ./. { };
      packages.default = self.packages.${system}.hoon-language-server;
      apps.default = {
        type = "app";
        program = "${self.packages.${system}.hoon-language-server}/bin/hoon-language-server";
      };
    };
  };
}
