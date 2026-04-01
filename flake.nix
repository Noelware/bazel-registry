{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {nixpkgs, ...}: let
    overlays = [];
    eachSystem = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system:
        f (import nixpkgs {
          inherit system overlays;
        }));
  in {
    formatter = eachSystem (pkgs: pkgs.alejandra);
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        name = "noelware-bzl-registry-dev";
        packages = with pkgs; [
          bazel_8
          bazel-buildtools
          python3
          openjdk
        ];
      };
    });
  };
}
