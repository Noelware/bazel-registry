# Copyright 2026 Noelware, LLC. <team@noelware.org>, et al.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
{
  description = "🌺💜 Extended C++ standard library";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    ...
  }: let
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
        ];
      };
    });
  };
}
