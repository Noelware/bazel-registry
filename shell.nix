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
let
  lockfile = builtins.fromJSON (builtins.readFile ./flake.lock);
  src = lockfile.nodes.flake-compat.locked;

  flake-compat = fetchTarball {
    url = "https://github.com/${src.owner}/${src.repo}/archive/${src.rev}.tar.gz";
    sha256 = src.narHash;
  };
in
  (import flake-compat {src = ./.;}).shellNix.default
